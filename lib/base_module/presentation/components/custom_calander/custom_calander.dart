import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../util/date_time_format.dart';
import '../../util/locale_digits.dart';

class CustomCalendarWidget extends StatefulWidget {
  final Function(DateTime)? onDaySelected;
  final DateTime firstDay;
  final DateTime lastDay;
  final CalendarFormat initialFormat;
  final bool formatButtonVisible;
  final bool titleCentered;
  final bool showWeekNumbers;
  final bool showHeader;
  final bool showHeaderText;
  final Color outsideDayColor;
  final Color selectedDayColor;
  final Color todayDayColor;
  final Color dayTextColor;
  final TextStyle? dayTextStyle;
  final TextStyle? selectedDayTextStyle;
  final TextStyle? todayDayTextStyle;
  final TextStyle? dowTextStyle;
  final TextStyle? weekNumberTextStyle;
  final Color headerIconColor;
  final bool outsideDaysVisible;
  final Color backgroundColor;
  final Color weekendTextColor;
  final Color holidayTextColor;
  final Gradient? todayGradient;
  final Gradient? selectedDayGradient;
  final Gradient? outsideDayGradient;
  final Map<DateTime, Gradient>? markedDatesMap;

  CustomCalendarWidget({
    super.key,
    this.onDaySelected,
    DateTime? firstDay,
    DateTime? lastDay,
    this.initialFormat = CalendarFormat.week,
    this.formatButtonVisible = false,
    this.titleCentered = true,
    this.showWeekNumbers = false,
    this.showHeader = true,
    this.showHeaderText = true,
    this.outsideDayColor = Colors.transparent,
    this.selectedDayColor = Colors.red,
    this.todayDayColor = Colors.deepPurple,
    this.dayTextColor = Colors.black,
    this.dayTextStyle,
    this.selectedDayTextStyle,
    this.todayDayTextStyle,
    this.dowTextStyle,
    this.weekNumberTextStyle,
    this.headerIconColor = Colors.grey,
    this.outsideDaysVisible = false,
    this.backgroundColor = Colors.white,
    this.weekendTextColor = Colors.red,
    this.holidayTextColor = Colors.blue,
    this.todayGradient,
    this.outsideDayGradient,
    this.selectedDayGradient,
    this.markedDatesMap = const {},
  })  : firstDay = firstDay ?? DateTime.utc(2010, 10, 16),
        lastDay = lastDay ?? DateTime.utc(2030, 3, 14);

  @override
  _CustomCalendarWidgetState createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = widget.initialFormat;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: TableCalendar(
        firstDay: widget.firstDay,
        lastDay: widget.lastDay,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        daysOfWeekHeight: 20, // Here to check  the height  issue
        availableCalendarFormats: const {
          CalendarFormat.week: 'Week',
        },
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            widget.onDaySelected?.call(selectedDay);
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: widget.outsideDaysVisible,
          defaultTextStyle:
              widget.dayTextStyle ?? TextStyle(color: widget.dayTextColor),
          weekendTextStyle: TextStyle(color: widget.weekendTextColor),
          holidayTextStyle: TextStyle(color: widget.holidayTextColor),
        ),
        headerStyle: widget.showHeader
            ? HeaderStyle(
                formatButtonVisible: widget.formatButtonVisible,
                titleCentered: widget.titleCentered,
                titleTextFormatter:
                    widget.showHeaderText ? null : (date, locale) => '',
                leftChevronIcon:
                    Icon(Icons.chevron_left, color: widget.headerIconColor),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: widget.headerIconColor),
              )
            : HeaderStyle(
                formatButtonVisible: false,
                titleCentered: widget.titleCentered,
                titleTextFormatter: (date, locale) => '',
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleTextStyle:
                    const TextStyle(height: 0, color: Colors.transparent),
              ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle:
              widget.dowTextStyle ?? TextStyle(color: widget.dayTextColor),
          weekendStyle: TextStyle(color: widget.weekendTextColor),
        ),
        weekNumbersVisible: widget.showWeekNumbers,
        calendarBuilders: CalendarBuilders(
          outsideBuilder: (context, day, focusedDay) {
            return _buildDayContainer(day, widget.outsideDayColor,
                gradient: widget.outsideDayGradient);
          },
          defaultBuilder: (context, day, focusedDay) {
            return _buildDayContainer(day, widget.outsideDayColor,
                gradient: widget.outsideDayGradient);
          },
          selectedBuilder: (context, day, focusedDay) {
            return _buildDayContainer(day, widget.selectedDayColor,
                isSelected: true, gradient: widget.selectedDayGradient);
          },
          todayBuilder: (context, day, focusedDay) {
            return _buildDayContainer(
              day,
              widget.todayDayColor,
              isSelected: true,
              gradient: widget.todayGradient,
            );
          },
          dowBuilder: (context, day) {
            final text = AppDateTimeFormat.formatDayShort(day);
            return Center(
              child: Text(
                text,
                style: widget.dowTextStyle ??
                    TextStyle(
                      color: day.weekday == DateTime.sunday
                          ? Colors.red
                          : Colors.grey,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayContainer(DateTime day, Color color,
      {bool isSelected = false, Gradient? gradient}) {
    final Gradient? markerColor = widget.markedDatesMap?[day];
    final bool isMarked = markerColor != null;

    return Container(
      margin: const EdgeInsets.all(7.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: markerColor ?? gradient,
        shape: BoxShape.circle,
      ),
      child: Text(
        LocaleDigits.ofInt(day.day),
        style: (isMarked || isSelected
                ? (widget.selectedDayTextStyle ??
                    Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ))
                : widget.dayTextStyle) ??
            Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: widget.dayTextColor,
                ),
      ),
    );
  }
}


















