import 'package:coin_saver/constants/period_enum.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/transaction/transaction_entity.dart';
import '../bloc/cubit/selected_date/selected_date_cubit.dart';
import '../bloc/time_period/time_period_bloc.dart';


class DayNavigationWidget extends StatefulWidget {
  final AccountEntity account;
  final DateTime dateTime;
  final bool isIncome;
  final List<TransactionEntity> transactions;
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
  String formatDateyMMMMd(DateTime dateTime) {
    String formattedDate = DateFormat.yMMMMd().format(dateTime);

    return formattedDate;
  }

  String formatDateM(DateTime dateTime) {
    String formattedDate = DateFormat.MMMMd().format(dateTime);

    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
  }

  String updateSelectedPeriodText(selectedPeriod, DateTime selectedDate) {
    switch (selectedPeriod) {
      case Period.day:
        context
            .read<TimePeriodBloc>()
            .add(SetDayPeriod(selectedDate: selectedDate));
        return formatDateyMMMMd(selectedDate) ==
                formatDateyMMMMd(DateTime.now())
            ? "Today"
            : formatDateyMMMMd(selectedDate) ==
                    formatDateyMMMMd(
                        DateTime.now().subtract(const Duration(days: 1)))
                ? "Yesterday"
                : formatDateyMMMMd(selectedDate);
      case Period.week:
        context
            .read<TimePeriodBloc>()
            .add(SetWeekPeriod(selectedDate: selectedDate));
        return "${formatDateM(selectedDate.subtract(Duration(days: selectedDate.weekday - 1)))} - ${formatDateyMMMMd(selectedDate.subtract(Duration(days: selectedDate.weekday - 7)))}";

      case Period.month:
        context
            .read<TimePeriodBloc>()
            .add(SetMonthPeriod(selectedDate: selectedDate));
        final startOfMonth = DateTime(selectedDate.year, selectedDate.month);
        final endOfMonth = DateTime(selectedDate.year, selectedDate.month + 1)
            .subtract(const Duration(days: 1));
        return "${formatDateM(startOfMonth)} - ${formatDateM(endOfMonth)}";
      case Period.year:
        context
            .read<TimePeriodBloc>()
            .add(SetYearPeriod(selectedDate: selectedDate));
        return DateFormat("yyyy").format(selectedDate);
      case Period.period:
        return "";
      default:
        return "";
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeriodCubit, Period>(
      builder: (context, selectedPeriod) {
        return BlocBuilder<SelectedDateCubit, DateTime>(
          builder: (context, selectedDate) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            // SelectedDate
                            context
                                .read<SelectedDateCubit>()
                                .moveBackward(selectedPeriod);

                            // MainTransactions Sort
                            context.read<TimePeriodBloc>().add(SetDayPeriod(
                                  selectedDate: selectedDate,
                                ));
                            updateSelectedPeriodText(
                                selectedPeriod, selectedDate);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        updateSelectedPeriodText(selectedPeriod, selectedDate),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // await  Hive.box<MainTransactionModel>(BoxConst.mainTransactions).clear();
                            },
                            child: Icon(
                              Icons.calendar_month_outlined,
                            ),
                          ),
                          IconButton(
                            onPressed: selectedDate.isBefore(DateTime.now()
                                    .subtract(const Duration(days: 1)))
                                ? () {
                                    // SelectedDate
                                    context
                                        .read<SelectedDateCubit>()
                                        .moveForward(
                                          selectedPeriod,
                                        );
                                    updateSelectedPeriodText(
                                        selectedPeriod, selectedDate);
                                  }
                                : null,
                            icon: Icon(
                              Icons.arrow_forward_ios,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
