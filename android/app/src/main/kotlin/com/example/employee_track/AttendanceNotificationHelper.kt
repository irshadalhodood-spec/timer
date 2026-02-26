package com.example.employee_track

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
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
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat

object AttendanceNotificationHelper {
    private const val CHANNEL_ID = "employee_track_attendance"
    const val NOTIFICATION_ID = 1001

    const val EXTRA_ATTENDANCE_ACTION = "attendance_action"

    fun showOrUpdate(
        context: Context,
        checkInAtIso: String,
        breakSeconds: Int,
        workedSeconds: Int,
        isOnBreak: Boolean,
        expectedWorkSeconds: Int,
        breakSegments: List<Pair<Int, Int>> = emptyList(),
        fromService: Boolean = false,
    ) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (context.checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                != android.content.pm.PackageManager.PERMISSION_GRANTED
            ) return
        }

        ensureChannel(context)

        val (title, content) = buildContent(
            context = context,
            checkInAtIso = checkInAtIso,
            breakSeconds = breakSeconds,
            workedSeconds = workedSeconds,
            isOnBreak = isOnBreak,
        )

        // Worked-time chip label: show time in worked format
        val workedChip = formatDuration(workedSeconds)

        val contentIntent = PendingIntent.getActivity(
            context,
            0,
            Intent(context, MainActivity::class.java).apply { flags = Intent.FLAG_ACTIVITY_SINGLE_TOP },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        // Broadcast-based pending intents — work even when app is killed
        fun actionBroadcast(action: String): PendingIntent = PendingIntent.getBroadcast(
            context,
            action.hashCode(),
            Intent(context, NotificationActionReceiver::class.java).apply {
                putExtra(EXTRA_ATTENDANCE_ACTION, action)
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val totalMax = expectedWorkSeconds.coerceAtLeast(1)
        val workColor      = ContextCompat.getColor(context, R.color.notification_progress_work)
        val breakColor     = ContextCompat.getColor(context, R.color.notification_progress_break)
        val otColor        = ContextCompat.getColor(context, R.color.notification_progress_ot)
        val remainingColor = ContextCompat.getColor(context, R.color.notification_progress_remaining)

        val density = context.resources.displayMetrics.density
        val progressBitmap = createTimelineProgressBarBitmap(
            totalWidth          = (320 * density).toInt().coerceAtLeast(200),
            barHeightPx         = (8 * density).toInt().coerceAtLeast(6),
            checkInAtIso        = checkInAtIso,
            expectedWorkSeconds = totalMax,
            breakSegments       = breakSegments,
            workColor           = workColor,
            breakColor          = breakColor,
            otColor             = otColor,
            remainingColor      = remainingColor,
        )

        // Choose chip colours based on on-break vs working state
        val chipBgColor   = if (isOnBreak)
            ContextCompat.getColor(context, R.color.notif_chip_bg_break)
        else
            ContextCompat.getColor(context, R.color.notif_chip_bg)
        val chipTextColor = if (isOnBreak)
            ContextCompat.getColor(context, R.color.notif_chip_text_break)
        else
            ContextCompat.getColor(context, R.color.notif_chip_text)

        val customView = RemoteViews(context.packageName, R.layout.notification_attendance).apply {
            setTextViewText(R.id.notification_title, title)
            setTextViewText(R.id.notification_content, content)
            setTextViewText(R.id.notification_worked_chip, workedChip)
            setInt(R.id.notification_worked_chip, "setBackgroundColor", chipBgColor)
            setTextColor(R.id.notification_worked_chip, chipTextColor)
            setImageViewBitmap(R.id.notification_progress_bar, progressBitmap)
            setOnClickPendingIntent(R.id.notification_btn_check_out,  actionBroadcast("checkOut"))
            setOnClickPendingIntent(R.id.notification_btn_start_break, actionBroadcast("startBreak"))
            setOnClickPendingIntent(R.id.notification_btn_end_break,   actionBroadcast("endBreak"))
            setViewVisibility(R.id.notification_btn_start_break, if (isOnBreak) View.GONE else View.VISIBLE)
            setViewVisibility(R.id.notification_btn_end_break,   if (isOnBreak) View.VISIBLE else View.GONE)
        }

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_menu_my_calendar)
            .setContentTitle(title)
            .setContentText(content)
            .setContentIntent(contentIntent)
            .setCustomContentView(customView)
            .setCustomBigContentView(customView)
            .setColor(ContextCompat.getColor(context, R.color.notification_accent))
            .setOngoing(true)
            .setSilent(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_STATUS)
            .build()

        if (fromService && context is Service) {
            context.startForeground(NOTIFICATION_ID, notification)
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                if (context.checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)
                    == android.content.pm.PackageManager.PERMISSION_GRANTED) {
                    NotificationManagerCompat.from(context).notify(NOTIFICATION_ID, notification)
                }
            } else {
                NotificationManagerCompat.from(context).notify(NOTIFICATION_ID, notification)
            }
        }
    }

    private fun ensureChannel(context: Context) {
        val channel = NotificationChannel(
            CHANNEL_ID,
            context.getString(R.string.notification_channel_attendance),
            NotificationManager.IMPORTANCE_LOW,
        ).apply { setShowBadge(false) }
        (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
            .createNotificationChannel(channel)
    }

    private fun buildContent(
        context: Context,
        checkInAtIso: String,
        breakSeconds: Int,
        workedSeconds: Int,
        isOnBreak: Boolean,
    ): Pair<String, String> {
        val startedAt = formatTimeFromIso(checkInAtIso)
        val breakStr  = formatDuration(breakSeconds)
        val workedStr = formatDuration(workedSeconds)
        val title = context.getString(
            if (isOnBreak) R.string.notification_title_on_break
            else           R.string.notification_title_clocked_in
        )
        val content = if (isOnBreak) {
            context.getString(R.string.notification_on_break, startedAt, breakStr, workedStr)
        } else {
            context.getString(R.string.notification_working, startedAt, breakStr, workedStr)
        }
        return title to content
    }

    private fun formatTimeFromIso(iso: String): String {
        return try {
            val date = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", java.util.Locale.US)
                .apply { timeZone = java.util.TimeZone.getDefault() }
                .parse(iso.take(19))
            if (date != null) java.text.SimpleDateFormat("h:mm a", java.util.Locale.getDefault()).format(date)
            else iso
        } catch (_: Exception) { iso }
    }

    /** Wall-clock seconds since check-in; non-negative. */
    private fun secondsSinceCheckIn(checkInAtIso: String): Int {
        return try {
            val checkIn = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", java.util.Locale.US)
                .apply { timeZone = java.util.TimeZone.getDefault() }
                .parse(checkInAtIso.take(19)) ?: return 0
            ((System.currentTimeMillis() - checkIn.time) / 1000).toInt().coerceAtLeast(0)
        } catch (_: Exception) { 0 }
    }

    private fun formatDuration(totalSeconds: Int): String {
        val h = totalSeconds / 3600
        val m = (totalSeconds % 3600) / 60
        return if (h > 0) "${h}h ${m}m" else "${m}m"
    }

    /**
     * Draws work/break/OT/remaining segments proportional to [expectedWorkSeconds].
     * The bar auto-computes 'now' from [checkInAtIso] so it stays live in the service.
     */
    private fun createTimelineProgressBarBitmap(
        totalWidth: Int,
        barHeightPx: Int,
        checkInAtIso: String,
        expectedWorkSeconds: Int,
        breakSegments: List<Pair<Int, Int>>,
        workColor: Int,
        breakColor: Int,
        otColor: Int,
        remainingColor: Int,
    ): Bitmap {
        val totalElapsed = secondsSinceCheckIn(checkInAtIso)
        val totalBreakSec = breakSegments.sumOf { (s, e) -> (e - s).coerceAtLeast(0) }
        val netWorked = (totalElapsed - totalBreakSec).coerceAtLeast(0)
        val isOt = netWorked > expectedWorkSeconds

        // Total bar represents: expectedWorkSeconds (+ any OT overflow) + remaining(0 if OT)
        val totalMax = if (isOt) totalElapsed.coerceAtLeast(expectedWorkSeconds) else expectedWorkSeconds
        val currentOffset = totalElapsed.coerceIn(0, totalMax)

        val widthF = totalWidth.toFloat()
        val scale  = widthF / totalMax.coerceAtLeast(1)

        val breaks = breakSegments
            .map { (s, e) -> s.coerceIn(0, totalMax) to e.coerceIn(0, totalMax) }
            .filter { (s, e) -> e > s }
            .sortedBy { it.first }
            .map { (s, e) -> s to e.coerceAtMost(currentOffset) }
            .filter { (s, e) -> e > s }

        val segments = mutableListOf<TimelineSeg>()
        var pos = 0

        for ((bStart, bEnd) in breaks) {
            if (bStart > pos) {
                val workEnd = bStart.coerceAtMost(currentOffset)
                if (workEnd > pos) appendWorkOrOt(segments, pos, workEnd, expectedWorkSeconds)
            }
            segments.add(TimelineSeg(bStart, bEnd, "break"))
            pos = bEnd
        }
        if (currentOffset > pos) appendWorkOrOt(segments, pos, currentOffset, expectedWorkSeconds)
        if (!isOt && totalMax > currentOffset) segments.add(TimelineSeg(currentOffset, totalMax, "remaining"))

        // Convert seconds → pixel widths
        val minPx = (1.5f * (totalWidth / 200f)).coerceAtLeast(1f)
        val rawWidths = segments.map { seg ->
            val sec = (seg.end - seg.start).coerceAtLeast(0)
            (sec * scale).coerceAtLeast(if (sec > 0) minPx else 0f)
        }.toMutableList()

        val sumRaw = rawWidths.sum()
        if (sumRaw > 0f && kotlin.math.abs(sumRaw - widthF) > 0.5f) {
            val ratio = widthF / sumRaw
            for (i in rawWidths.indices) rawWidths[i] = (rawWidths[i] * ratio).coerceIn(0f, widthF)
        }
        if (rawWidths.isNotEmpty()) {
            val snap = rawWidths.sum()
            rawWidths[rawWidths.size - 1] = (rawWidths.last() + (widthF - snap)).coerceIn(0f, widthF)
        }

        // Draw
        val bitmap = Bitmap.createBitmap(totalWidth, barHeightPx, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val r  = (barHeightPx / 2f)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)

        canvas.clipPath(Path().apply {
            addRoundRect(RectF(0f, 0f, widthF, barHeightPx.toFloat()), r, r, Path.Direction.CW)
        })

        var left = 0f
        for (i in segments.indices) {
            val w = rawWidths.getOrElse(i) { 0f }
            if (w <= 0f) continue
            val right = (left + w).coerceAtMost(widthF)
            paint.color = when (segments[i].type) {
                "break"     -> breakColor
                "ot"        -> otColor
                "remaining" -> remainingColor
                else        -> workColor
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

    /** Appends one or two TimelineSeg entries split at [expectedWork]: work + ot. */
    private fun appendWorkOrOt(
        segments: MutableList<TimelineSeg>,
        start: Int,
        end: Int,
        expectedWork: Int,
    ) {
        if (start >= end) return
        when {
            end <= expectedWork        -> segments.add(TimelineSeg(start, end, "work"))
            start >= expectedWork      -> segments.add(TimelineSeg(start, end, "ot"))
            else -> {
                segments.add(TimelineSeg(start, expectedWork, "work"))
                segments.add(TimelineSeg(expectedWork, end, "ot"))
            }
        }
    }

    private data class TimelineSeg(val start: Int, val end: Int, val type: String)

    fun clear(context: Context) {
        NotificationManagerCompat.from(context).cancel(NOTIFICATION_ID)
    }
}
