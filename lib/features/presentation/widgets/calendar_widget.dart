import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants/period_enum.dart';
import '../bloc/cubit/period/period_cubit.dart';
import '../bloc/cubit/selected_date/selected_date_cubit.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDate;
  late CalendarFormat _format;
  DateTime? _selectedDayConverted;
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  AlertDialog build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .9, // Set the desired width
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<PeriodCubit, Period>(
              builder: (context, period) {
                if (period == Period.day || period == Period.month) {
                  _format = CalendarFormat.month;

                } else {
                  _format = CalendarFormat.week;
                }
                return TableCalendar(
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarFormat: _format,
                  headerVisible: true,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  focusedDay: _selectedDate,
                  firstDay: DateTime(2000),
                  lastDay: DateTime.now(),
                  currentDay: _selectedDate,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                    _selectedDayConverted = DateTime(
                        selectedDay.year, selectedDay.month, selectedDay.day);
                  },
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        MyButtonWidget(
          title: "Done",
          onTap: () {
            if (_selectedDayConverted != null) {
              context
                  .read<SelectedDateCubit>()
                  .changeStartDate(_selectedDayConverted!);
            }
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
