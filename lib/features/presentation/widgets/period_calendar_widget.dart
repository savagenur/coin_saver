import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants/period_enum.dart';
import '../../domain/entities/transaction/transaction_entity.dart';
import '../bloc/cubit/period/period_cubit.dart';
import '../bloc/cubit/selected_date/selected_date_cubit.dart';

class PeriodCalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final List<TransactionEntity> transactions;

  const PeriodCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.transactions,
  });

  @override
  State<PeriodCalendarWidget> createState() => _PeriodCalendarWidgetState();
}

class _PeriodCalendarWidgetState extends State<PeriodCalendarWidget> {
  late Period _period;
  DateTime? _selectedStartConverted;
  DateTime? _selectedEndConverted;
  late DateTime _selectedStart;
  DateTime? _selectedEnd;
  @override
  void initState() {
    super.initState();
    _selectedStart = widget.selectedDate;
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
                    return TableCalendar(
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarFormat: CalendarFormat.month,
                      headerVisible: true,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                      ),
                      focusedDay: _selectedStart,
                      firstDay: DateTime(2000),
                      lastDay: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      currentDay: _selectedStart,
                      onDaySelected: (selectedDay, focusedDay) {
                        if ( _selectedEnd != null) {
                          setState(() {
                            _selectedStart = selectedDay;
                            _selectedEnd = null;
                          });
                        } else if (
                            _selectedEnd == null) {
                          if (selectedDay.isAfter(_selectedStart)) {
                            setState(() {
                              _selectedEnd = selectedDay;
                            });
                          } else {
                            setState(() {
                              _selectedEnd = _selectedStart;
                              _selectedStart = selectedDay;
                            });
                          }
                          _selectedStartConverted = DateTime(
                              _selectedStart.year,
                              _selectedStart.month,
                              _selectedStart.day);

                          _selectedEndConverted = DateTime(_selectedEnd!.year,
                              _selectedEnd!.month, _selectedEnd!.day);
                        }
                      },
                      rangeStartDay: _selectedStart,
                      rangeEndDay: _selectedEnd,
                      rangeSelectionMode: RangeSelectionMode.toggledOn,
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
            if (_selectedEnd != null) {
              context.read<SelectedDateCubit>().changeStartEnd(
                  _selectedStartConverted!, _selectedEndConverted!);
            } else {
              context
                  .read<SelectedDateCubit>()
                  .changeStartEnd(_selectedStart, _selectedStart);
            }
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
