package com.example.employee_track

import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF
import android.os.Build
import android.view.View
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
        breakSegments: List<Pair<Int, Int>> = emptyList(),
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
        val workColor = ContextCompat.getColor(context, R.color.notification_progress_work)
        val breakColor = ContextCompat.getColor(context, R.color.notification_progress_break)
        val remainingColor = ContextCompat.getColor(context, R.color.notification_progress_remaining)

        val progressBitmap = createTimelineProgressBarBitmap(
            context = context,
            totalWidth = (320 * context.resources.displayMetrics.density).toInt().coerceAtLeast(200),
            barHeightPx = (10 * context.resources.displayMetrics.density).toInt().coerceAtLeast(8),
            checkInAtIso = checkInAtIso,
            expectedWorkSeconds = totalMax,
            breakSegments = breakSegments,
            workColor = workColor,
            breakColor = breakColor,
            remainingColor = remainingColor,
        )

        val customView = RemoteViews(context.packageName, R.layout.notification_attendance).apply {
            setTextViewText(R.id.notification_title, title)
            setTextViewText(R.id.notification_content, content)
            setImageViewBitmap(R.id.notification_progress_bar, progressBitmap)
            setOnClickPendingIntent(R.id.notification_btn_check_out, actionIntent("checkOut"))
            setOnClickPendingIntent(R.id.notification_btn_start_break, actionIntent("startBreak"))
            setOnClickPendingIntent(R.id.notification_btn_end_break, actionIntent("endBreak"))
            // Show only one break button: End Break when on break, Start Break when not
            setViewVisibility(R.id.notification_btn_start_break, if (isOnBreak) View.GONE else View.VISIBLE)
            setViewVisibility(R.id.notification_btn_end_break, if (isOnBreak) View.VISIBLE else View.GONE)
        }

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_menu_my_calendar)
            .setContentTitle(title)
            .setContentText(content)
            .setContentIntent(pendingContent)
            .setCustomContentView(customView)
            .setCustomBigContentView(customView)
            .setColor(ContextCompat.getColor(context, R.color.notification_accent))
            .setColorized(true)
            .setOngoing(true)
            .setSilent(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_STATUS)
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

    /** Seconds from check-in time to now; non-negative. */
    private fun secondsSinceCheckIn(checkInAtIso: String): Int {
        return try {
            val fmt = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", java.util.Locale.US).apply {
                timeZone = java.util.TimeZone.getDefault()
            }
            val checkIn = fmt.parse(checkInAtIso.take(19)) ?: return 0
            val now = System.currentTimeMillis()
            ((now - checkIn.time) / 1000).toInt().coerceAtLeast(0)
        } catch (_: Exception) {
            0
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

    /**
     * Draws the full work timeline (0 .. expectedWorkSeconds). Work = green, breaks at their actual
     * positions = yellow, remaining (future) = red. Breaks are scattered on the timeline.
     */
    private fun createTimelineProgressBarBitmap(
        context: Context,
        totalWidth: Int,
        barHeightPx: Int,
        checkInAtIso: String,
        expectedWorkSeconds: Int,
        breakSegments: List<Pair<Int, Int>>,
        workColor: Int,
        breakColor: Int,
        remainingColor: Int,
    ): Bitmap {
        val totalMax = expectedWorkSeconds.coerceAtLeast(1)
        val currentOffset = secondsSinceCheckIn(checkInAtIso).coerceIn(0, totalMax)
        val widthF = totalWidth.toFloat()
        val scale = widthF / totalMax

        // Breaks that fall within [0, currentOffset], sorted by start; clamp to [0, currentOffset]
        val breaks = breakSegments
            .map { (s, e) -> s.coerceIn(0, totalMax) to e.coerceIn(0, totalMax) }
            .filter { (s, e) -> e > s }
            .sortedBy { it.first }
            .map { (s, e) -> s to e.coerceAtMost(currentOffset) }
            .filter { (s, e) -> e > s }

        // Build ordered segments: (startSec, endSec, type) where type = "work" | "break" | "remaining"
        data class Seg(val start: Int, val end: Int, val type: String)
        val segments = mutableListOf<Seg>()
        var pos = 0
        for ((bStart, bEnd) in breaks) {
            if (bStart > pos) segments.add(Seg(pos, bStart, "work"))
            segments.add(Seg(bStart, bEnd, "break"))
            pos = bEnd
        }
        if (currentOffset > pos) segments.add(Seg(pos, currentOffset, "work"))
        if (totalMax > currentOffset) segments.add(Seg(currentOffset, totalMax, "remaining"))

        val minSegmentPx = (2 * (totalWidth / 100f)).coerceAtLeast(1f)
        val widthsPx = segments.map { seg ->
            val sec = (seg.end - seg.start).coerceAtLeast(0)
            (sec * scale).coerceAtLeast(if (sec > 0) minSegmentPx else 0f)
        }
        var sumPx = widthsPx.sum()
        val scaleRatio = if (sumPx > 0f && kotlin.math.abs(sumPx - widthF) > 0.5f) widthF / sumPx else 1f
        val finalWidths = widthsPx.map { (it * scaleRatio).coerceIn(0f, widthF) }.toMutableList()
        if (finalWidths.isNotEmpty()) {
            val actualSum = finalWidths.sum()
            finalWidths[finalWidths.size - 1] = (finalWidths.last() + (widthF - actualSum)).coerceIn(0f, widthF)
        }

        val bitmap = Bitmap.createBitmap(totalWidth, barHeightPx, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val cornerRadiusPx = (8 * (totalWidth / 320f)).coerceAtMost(barHeightPx / 2f)
        val fullRect = RectF(0f, 0f, widthF, barHeightPx.toFloat())
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)

        val path = Path().apply { addRoundRect(fullRect, cornerRadiusPx, cornerRadiusPx, Path.Direction.CW) }
        canvas.clipPath(path)

        var left = 0f
        for (i in segments.indices) {
            val w = finalWidths.getOrElse(i) { 0f }
            if (w <= 0f) continue
            val right = (left + w).coerceAtMost(widthF)
            paint.color = when (segments[i].type) {
                "break" -> breakColor
                "remaining" -> remainingColor
                else -> workColor
            }
            canvas.drawRect(left, 0f, right, barHeightPx.toFloat(), paint)
            left = right
        }
        if (left < widthF) {
            paint.color = remainingColor
            canvas.drawRect(left, 0f, widthF, barHeightPx.toFloat(), paint)
        }
        return bitmap
    }

    fun clear(context: Context) {
        NotificationManagerCompat.from(context).cancel(NOTIFICATION_ID)
    }
}
