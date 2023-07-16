import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants/period_enum.dart';
import '../../domain/entities/transaction/transaction_entity.dart';
import '../bloc/cubit/period/period_cubit.dart';
import '../bloc/cubit/selected_date/selected_date_cubit.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final List<TransactionEntity> transactions;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.transactions,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDate;
  late DateTime _selectedEnd;
  DateTime? _selectedDayConverted;
  late Period _period;
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
                _period = period;
                return BlocBuilder<SelectedDateCubit, DateRange>(
                  builder: (context, dateRange) {
                    var selectedDate = dateRange.startDate;
                    _selectedEnd = dateRange.endDate;
                    return TableCalendar(
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarFormat: CalendarFormat.month,
                      headerVisible: true,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                      ),
                      focusedDay: _selectedDate,
                      firstDay: DateTime(2000),
                      lastDay: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      currentDay: _selectedDate,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDate = selectedDay;
                        });
                        _selectedDayConverted = DateTime(selectedDay.year,
                            selectedDay.month, selectedDay.day);
                      },
                    );
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
