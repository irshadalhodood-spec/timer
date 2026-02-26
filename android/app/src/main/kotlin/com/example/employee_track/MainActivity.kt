package com.example.employee_track

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var attendanceChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        deliverPendingNotificationAction(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        deliverPendingNotificationAction(intent)
    }

    private fun deliverPendingNotificationAction(intent: Intent?) {
        val action = intent?.getStringExtra(AttendanceNotificationHelper.EXTRA_ATTENDANCE_ACTION) ?: return
        intent.removeExtra(AttendanceNotificationHelper.EXTRA_ATTENDANCE_ACTION)
        val noOpResult = object : MethodChannel.Result {
            override fun success(result: Any?) {}
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
            override fun notImplemented() {}
        }
        attendanceChannel?.invokeMethod("notificationAction", action, noOpResult)
            ?: Handler(Looper.getMainLooper()).postDelayed({
                attendanceChannel?.invokeMethod("notificationAction", action, noOpResult)
            }, 500)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        attendanceChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.employee_track/attendance_notification",
        ).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "showAttendanceNotification" -> {
                        val checkInAtIso = call.argument<String>("checkInAtIso") ?: ""
                        val breakSeconds = call.argument<Int>("breakSeconds") ?: 0
                        val workedSeconds = call.argument<Int>("workedSeconds") ?: 0
                        val isOnBreak = call.argument<Boolean>("isOnBreak") ?: false
                        val expectedWorkSeconds = call.argument<Int>("expectedWorkSeconds") ?: 28800
                        val rawSegments = call.argument<ArrayList<*>>("breakSegments") ?: arrayListOf<Any>()
                        val breakSegmentsList = rawSegments.mapNotNull { item ->
                            @Suppress("UNCHECKED_CAST")
                            (item as? Map<String, Any>)?.let { m ->
                                val s = (m["startSeconds"] as? Number)?.toInt() ?: return@let null
                                val e = (m["endSeconds"] as? Number)?.toInt() ?: return@let null
                                if (e > s) arrayListOf(s, e) else null
                            }
                        }

                        // Start (or update) the foreground timer service so it ticks when app is closed
                        val serviceIntent = Intent(this@MainActivity, AttendanceTimerService::class.java).apply {
                            putExtra(AttendanceTimerService.EXTRA_CHECK_IN_ISO, checkInAtIso)
                            putExtra(AttendanceTimerService.EXTRA_BREAK_SECONDS, breakSeconds)
                            putExtra(AttendanceTimerService.EXTRA_IS_ON_BREAK, isOnBreak)
                            putExtra(AttendanceTimerService.EXTRA_EXPECTED_WORK_SECONDS, expectedWorkSeconds)
                            putExtra(AttendanceTimerService.EXTRA_BREAK_SEGMENTS, ArrayList(breakSegmentsList))
                        }
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startForegroundService(serviceIntent)
                        } else {
                            startService(serviceIntent)
                        }

                        // Also update notification immediately from the activity
                        val breakSegmentsPairs = breakSegmentsList.mapNotNull { pair ->
                            val s = pair.getOrNull(0) ?: return@mapNotNull null
                            val e = pair.getOrNull(1) ?: return@mapNotNull null
                            s to e
                        }
                        AttendanceNotificationHelper.showOrUpdate(
                            context = this@MainActivity,
                            checkInAtIso = checkInAtIso,
                            breakSeconds = breakSeconds,
                            workedSeconds = workedSeconds,
                            isOnBreak = isOnBreak,
                            expectedWorkSeconds = expectedWorkSeconds,
                            breakSegments = breakSegmentsPairs,
                        )
                        result.success(null)
                    }
                    "clearAttendanceNotification" -> {
                        // Stop the timer service and dismiss the notification
                        stopService(Intent(this@MainActivity, AttendanceTimerService::class.java))
                        AttendanceNotificationHelper.clear(this@MainActivity)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }
}
