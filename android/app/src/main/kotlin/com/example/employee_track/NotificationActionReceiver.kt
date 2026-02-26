package com.example.employee_track

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Receives attendance action broadcasts from notification buttons (Check Out, Start Break,
 * End Break). Works even when the Flutter app is killed.
 *
 * Launches MainActivity with the action extra so Flutter can handle it on resume.
 */
class NotificationActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.getStringExtra(AttendanceNotificationHelper.EXTRA_ATTENDANCE_ACTION)
            ?: return

        // Stop the timer service (Flutter will restart it if still checked in)
        context.stopService(Intent(context, AttendanceTimerService::class.java))

        // Bring MainActivity to foreground with the action
        val launch = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra(AttendanceNotificationHelper.EXTRA_ATTENDANCE_ACTION, action)
        }
        context.startActivity(launch)
    }
}
