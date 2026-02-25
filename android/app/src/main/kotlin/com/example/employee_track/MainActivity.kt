package com.example.employee_track

import android.content.Intent
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
                        val breakSegments = rawSegments.mapNotNull { item ->
                            @Suppress("UNCHECKED_CAST")
                            (item as? Map<String, Any>)?.let { m ->
                                val s = (m["startSeconds"] as? Number)?.toInt() ?: return@let null
                                val e = (m["endSeconds"] as? Number)?.toInt() ?: return@let null
                                if (e > s) s to e else null
                            }
                        }
                        AttendanceNotificationHelper.showOrUpdate(
                            context = this@MainActivity,
                            checkInAtIso = checkInAtIso,
                            breakSeconds = breakSeconds,
                            workedSeconds = workedSeconds,
                            isOnBreak = isOnBreak,
                            expectedWorkSeconds = expectedWorkSeconds,
                            breakSegments = breakSegments,
                        )
                        result.success(null)
                    }
                    "clearAttendanceNotification" -> {
                        AttendanceNotificationHelper.clear(this@MainActivity)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }
}
