import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SimpleCalendarWidget extends StatelessWidget {
  final void Function(DateTime) setDate;
  const SimpleCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.firstDay,
    required this.lastDay,
    required this.setDate,
  });

  final DateTime selectedDate;
  final DateTime firstDay;
  final DateTime lastDay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar(
            calendarFormat: CalendarFormat.month,
            focusedDay: selectedDate,
            firstDay: firstDay,
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            onDaySelected: (selectedDay, focusedDay) {
              setDate(focusedDay);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
