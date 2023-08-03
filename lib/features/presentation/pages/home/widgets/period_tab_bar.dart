import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants/constants.dart';
import '../../../../../constants/period_enum.dart';
import '../../../../domain/entities/transaction/transaction_entity.dart';
import '../../../bloc/cubit/period/period_cubit.dart';
import '../../../bloc/home_time_period/home_time_period_bloc.dart';
import '../../../widgets/period_calendar_widget.dart';

class PeriodTabBar extends StatelessWidget {
  final TabController tabController;
  final Period selectedPeriod;
  final DateTime selectedDate;
  final DateTime selectedDateEnd;
  final List<TransactionEntity> transactions;
  const PeriodTabBar(
      {super.key,
      required this.tabController,
      required this.selectedPeriod,
      required this.selectedDate,
      required this.selectedDateEnd,
      required this.transactions});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    Period _selectedPeriod = selectedPeriod;
    List transactionPeriodTitles = kGetTransactionPeriodTitles(context);
    return TabBar(
      controller: tabController,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
      indicatorColor: Theme.of(context).primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      unselectedLabelColor: Theme.of(context).primaryColor,
      onTap: (value) {
        _selectedPeriod = periodValues[value]!;
        switchTransactionsTimePeriod(
            context: context,
            period: _selectedPeriod,
            selectedDate: selectedDate,
            selectedDateEnd: selectedDateEnd,
            transactions: transactions);
      },
      tabs: transactionPeriodTitles
          .map(
            (e) => Tab(
              child: Text(
                e,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          )
          .toList(),
    );
  }
}

void switchTransactionsTimePeriod({
  required BuildContext context,
  required Period period,
  required DateTime selectedDate,
  required DateTime selectedDateEnd,
  required List<TransactionEntity> transactions,
}) {
  switch (period) {
    case Period.day:
      context
          .read<HomeTimePeriodBloc>()
          .add(SetDayPeriod(selectedDate: selectedDate));
      context.read<PeriodCubit>().changePeriod(period);
      break;
    case Period.week:
      context
          .read<HomeTimePeriodBloc>()
          .add(SetWeekPeriod(selectedDate: selectedDate));
      context.read<PeriodCubit>().changePeriod(period);

      break;
    case Period.month:
      context
          .read<HomeTimePeriodBloc>()
          .add(SetMonthPeriod(selectedDate: selectedDate));
      context.read<PeriodCubit>().changePeriod(period);

      break;
    case Period.year:
      context
          .read<HomeTimePeriodBloc>()
          .add(SetYearPeriod(selectedDate: selectedDate));
      context.read<PeriodCubit>().changePeriod(period);

      break;
    case Period.period:
      context.read<HomeTimePeriodBloc>().add(
          SetPeriod(selectedStart: selectedDate, selectedEnd: selectedDateEnd));
      context.read<PeriodCubit>().changePeriod(period);
      showDialog(
        context: context,
        builder: (context) {
          return PeriodCalendarWidget(
              selectedDate: selectedDate, transactions: transactions);
        },
      );

      break;
    default:
      0;
  }
}
