import 'package:coin_saver/constants/period_enum.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/presentation/bloc/main_time_period/main_time_period_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DayNavigationWidget extends StatefulWidget {
  final AccountEntity account;
  final DateTime dateTime;
  final bool isIncome;
  final List<MainTransactionEntity> transactions;
  final Period selectedPeriod;
  const DayNavigationWidget({
    super.key,
    required this.account,
    required this.dateTime,
    required this.transactions,
    required this.isIncome,
    this.selectedPeriod = Period.day,
  });

  @override
  State<DayNavigationWidget> createState() => _DayNavigationWidgetState();
}

class _DayNavigationWidgetState extends State<DayNavigationWidget> {
  String formatDate(DateTime dateTime) {
    String formattedDate = DateFormat.yMMMMd().format(dateTime);

    return formattedDate;
  }

  String _selectedPeriodText = "";

  @override
  void initState() {
    super.initState();
    updateSelectedPeriodText();
  }

  void updateSelectedPeriodText() {
    setState(() {
      switch (widget.selectedPeriod) {
        case Period.day:
          _selectedPeriodText =
              formatDate(widget.dateTime) == formatDate(DateTime.now())
                  ? "Today"
                  : formatDate(widget.dateTime) ==
                          formatDate(
                              DateTime.now().subtract(const Duration(days: 1)))
                      ? "Yesterday"
                      : formatDate(widget.dateTime);
        case Period.week:
          _selectedPeriodText =
              "${formatDate(widget.dateTime.subtract(Duration(days: widget.dateTime.weekday - 1)))} - ${formatDate(widget.dateTime.subtract(Duration(days: widget.dateTime.weekday - 7)))}";
          break;
        case Period.month:
          break;
        case Period.year:
          break;
        case Period.period:
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () async {
                // MainTransactions Sort
                context.read<MainTimePeriodBloc>().add(SetDayPeriod(
                      selectedDate:
                          widget.dateTime.subtract(const Duration(days: 1)),
                    ));
                await Future.delayed(Duration(milliseconds: 200));

                updateSelectedPeriodText();
              },
              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    // await  Hive.box<MainTransactionModel>(BoxConst.mainTransactions).clear();
                  },
                  icon: Icon(
                    Icons.calendar_month_outlined,
                  ),
                ),
                IconButton(
                  onPressed: widget.dateTime.isBefore(
                          DateTime.now().subtract(const Duration(days: 1)))
                      ? () async {
                          // Can't go forward from today
                          context.read<MainTimePeriodBloc>().add(SetDayPeriod(
                                selectedDate: widget.dateTime
                                    .add(const Duration(days: 1)),
                              ));
                          await Future.delayed(Duration(milliseconds: 200));

                          updateSelectedPeriodText();
                        }
                      : null,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          _selectedPeriodText,
          style: TextStyle(decoration: TextDecoration.underline),
        ),
      ],
    );
  }
}
