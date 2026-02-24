package com.example.employee_track

import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.res.ColorStateList
import android.os.Build
import android.widget.RemoteViews
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat

object AttendanceNotificationHelper {
    private const val CHANNEL_ID = "employee_track_attendance"
    private const val NOTIFICATION_ID = 1001

    const val EXTRA_ATTENDANCE_ACTION = "attendance_action"

    fun showOrUpdate(
        context: Context,
        checkInAtIso: String,
        breakSeconds: Int,
        workedSeconds: Int,
        isOnBreak: Boolean,
        expectedWorkSeconds: Int,
    ) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(context, android.Manifest.permission.POST_NOTIFICATIONS)
                != android.content.pm.PackageManager.PERMISSION_GRANTED
            ) {
                (context as? Activity)?.let { act ->
                    ActivityCompat.requestPermissions(
                        act,
                        arrayOf(android.Manifest.permission.POST_NOTIFICATIONS),
                        0,
                    )
                }
                return
            }
        }
        val channel = NotificationChannel(
            CHANNEL_ID,
            context.getString(R.string.notification_channel_attendance),
            NotificationManager.IMPORTANCE_LOW,
        ).apply { setShowBadge(false) }
        (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
            .createNotificationChannel(channel)

        val (title, content) = buildContent(
            context = context,
            checkInAtIso = checkInAtIso,
            breakSeconds = breakSeconds,
            workedSeconds = workedSeconds,
            isOnBreak = isOnBreak,
        )

        val contentIntent = Intent(context, MainActivity::class.java).apply { flags = Intent.FLAG_ACTIVITY_SINGLE_TOP }
        val pendingContent = PendingIntent.getActivity(
            context,
            0,
            contentIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        fun actionIntent(action: String) = PendingIntent.getActivity(
            context,
            action.hashCode(),
            Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_NEW_TASK
                putExtra(EXTRA_ATTENDANCE_ACTION, action)
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val totalMax = expectedWorkSeconds.coerceAtLeast(1)
        val work = workedSeconds.coerceIn(0, totalMax)
        val break_ = breakSeconds.coerceIn(0, totalMax)
        val remaining = (totalMax - work - break_).coerceIn(0, totalMax)

        val workStr = formatDuration(workedSeconds)
        val breakStr = formatDuration(breakSeconds)
        val remainingStr = formatDuration(remaining)

        val workColor = ContextCompat.getColor(context, R.color.notification_progress_work)
        val breakColor = ContextCompat.getColor(context, R.color.notification_progress_break)
        val remainingColor = ContextCompat.getColor(context, R.color.notification_progress_remaining)

        val customView = RemoteViews(context.packageName, R.layout.notification_attendance).apply {
            setTextViewText(R.id.notification_title, title)
            setTextViewText(R.id.notification_content, content)
            setProgressBar(R.id.notification_progress_work, totalMax, work, false)
            setProgressBar(R.id.notification_progress_break, totalMax, break_, false)
            setProgressBar(R.id.notification_progress_remaining, totalMax, remaining, false)
            setTextViewText(R.id.notification_label_work, context.getString(R.string.notification_progress_work_label) + "  " + workStr)
            setTextViewText(R.id.notification_label_break, context.getString(R.string.notification_progress_break_label) + "  " + breakStr)
            setTextViewText(R.id.notification_label_remaining, context.getString(R.string.notification_progress_remaining_label) + "  " + remainingStr)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            customView.setColorStateList(R.id.notification_progress_work, "setProgressTintList", ColorStateList.valueOf(workColor))
            customView.setColorStateList(R.id.notification_progress_break, "setProgressTintList", ColorStateList.valueOf(breakColor))
            customView.setColorStateList(R.id.notification_progress_remaining, "setProgressTintList", ColorStateList.valueOf(remainingColor))
        }

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_menu_my_calendar)
            .setContentTitle(title)
            .setContentText(content)
            .setContentIntent(pendingContent)
            .setCustomContentView(customView)
            .setColor(ContextCompat.getColor(context, R.color.notification_accent))
            .setColorized(true)
            .setOngoing(true)
            .setSilent(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_STATUS)
            .addAction(android.R.drawable.ic_menu_close_clear_cancel, context.getString(R.string.notification_action_check_out), actionIntent("checkOut"))
            .addAction(android.R.drawable.ic_media_pause, context.getString(R.string.notification_action_start_break), actionIntent("startBreak"))
            .addAction(android.R.drawable.ic_media_play, context.getString(R.string.notification_action_end_break), actionIntent("endBreak"))
            .build()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (context.checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) == android.content.pm.PackageManager.PERMISSION_GRANTED) {
                NotificationManagerCompat.from(context).notify(NOTIFICATION_ID, notification)
            }
        } else {
            NotificationManagerCompat.from(context).notify(NOTIFICATION_ID, notification)
        }
    }

    private fun buildContent(
        context: Context,
        checkInAtIso: String,
        breakSeconds: Int,
        workedSeconds: Int,
        isOnBreak: Boolean,
    ): Pair<String, String> {
        val startedAt = formatTimeFromIso(checkInAtIso)
        val breakStr = formatDuration(breakSeconds)
        val workedStr = formatDuration(workedSeconds)
        val title = context.getString(R.string.notification_title_clocked_in)
        val content = if (isOnBreak) {
            context.getString(R.string.notification_on_break, startedAt, breakStr, workedStr)
        } else {
            context.getString(R.string.notification_working, startedAt, breakStr, workedStr)
        }
        return title to content
    }

    private fun formatTimeFromIso(iso: String): String {
        return try {
            val date = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", java.util.Locale.US).apply {
                timeZone = java.util.TimeZone.getDefault()
            }.parse(iso.take(19))
            if (date != null) {
                java.text.SimpleDateFormat("h:mm a", java.util.Locale.getDefault()).format(date)
            } else iso
        } catch (_: Exception) {
            iso
        }
    }

    private fun formatDuration(totalSeconds: Int): String {
        val h = totalSeconds / 3600
        val m = (totalSeconds % 3600) / 60
        return when {
            h > 0 -> "${h}h ${m}m"
            else -> "${m}m"
        }
    }

    fun clear(context: Context) {
        NotificationManagerCompat.from(context).cancel(NOTIFICATION_ID)
    }
}
