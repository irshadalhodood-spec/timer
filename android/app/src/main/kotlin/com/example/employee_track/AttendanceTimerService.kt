package com.example.employee_track

import android.app.Service
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import android.os.Looper

/**
 * Foreground service that keeps the attendance notification alive and ticking
 * even when the Flutter app is closed.
 *
 * Started via MainActivity (method channel) with all required attendance state.
 * Ticks every 60 seconds to update the worked-time counter in the notification.
 */
class AttendanceTimerService : Service() {

    companion object {
        const val EXTRA_CHECK_IN_ISO = "checkInAtIso"
        const val EXTRA_BREAK_SECONDS = "breakSeconds"
        const val EXTRA_IS_ON_BREAK = "isOnBreak"
        const val EXTRA_EXPECTED_WORK_SECONDS = "expectedWorkSeconds"
        const val EXTRA_BREAK_SEGMENTS = "breakSegments" // ArrayList<ArrayList<Int>>

        private const val TICK_INTERVAL_MS = 60_000L // 1 minute
    }

    private val handler = Handler(Looper.getMainLooper())
    private var checkInAtIso: String = ""
    private var breakSeconds: Int = 0
    private var isOnBreak: Boolean = false
    private var expectedWorkSeconds: Int = 28800
    private var breakSegments: List<Pair<Int, Int>> = emptyList()

    private val tickRunnable = object : Runnable {
        override fun run() {
            updateNotification()
            handler.postDelayed(this, TICK_INTERVAL_MS)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        intent?.let {
            checkInAtIso = it.getStringExtra(EXTRA_CHECK_IN_ISO) ?: checkInAtIso
            breakSeconds = it.getIntExtra(EXTRA_BREAK_SECONDS, breakSeconds)
            isOnBreak = it.getBooleanExtra(EXTRA_IS_ON_BREAK, isOnBreak)
            expectedWorkSeconds = it.getIntExtra(EXTRA_EXPECTED_WORK_SECONDS, expectedWorkSeconds)

            @Suppress("UNCHECKED_CAST")
            val rawSegments = it.getSerializableExtra(EXTRA_BREAK_SEGMENTS) as? ArrayList<*>
            if (rawSegments != null) {
                breakSegments = rawSegments.mapNotNull { seg ->
                    (seg as? ArrayList<*>)?.let { pair ->
                        val s = (pair.getOrNull(0) as? Int) ?: return@let null
                        val e = (pair.getOrNull(1) as? Int) ?: return@let null
                        if (e > s) s to e else null
                    }
                }
            }
        }

        // Show/update notification immediately and make it a foreground service
        updateNotification()
        handler.removeCallbacks(tickRunnable)
        handler.postDelayed(tickRunnable, TICK_INTERVAL_MS)

        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(tickRunnable)
        super.onDestroy()
    }

    private fun workedSeconds(): Int {
        if (checkInAtIso.isEmpty()) return 0
        return try {
            val fmt = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", java.util.Locale.US).apply {
                timeZone = java.util.TimeZone.getDefault()
            }
            val checkIn = fmt.parse(checkInAtIso.take(19)) ?: return 0
            val elapsed = ((System.currentTimeMillis() - checkIn.time) / 1000).toInt().coerceAtLeast(0)
            (elapsed - breakSeconds).coerceAtLeast(0)
        } catch (_: Exception) {
            0
        }
    }

    private fun updateNotification() {
        if (checkInAtIso.isEmpty()) return
        AttendanceNotificationHelper.showOrUpdate(
            context = this,
            checkInAtIso = checkInAtIso,
            breakSeconds = breakSeconds,
            workedSeconds = workedSeconds(),
            isOnBreak = isOnBreak,
            expectedWorkSeconds = expectedWorkSeconds,
            breakSegments = breakSegments,
            fromService = true,
        )
    }
}
