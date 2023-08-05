import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../domain/entities/account/account_entity.dart';
import '../../../../domain/entities/category/category_entity.dart';
import '../../../../domain/entities/transaction/transaction_entity.dart';

class CircularChartWidget extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final DateTime _selectedDate;
  final TooltipBehavior _tooltipBehavior;
  final AccountEntity _account;
  final double _totalExpense;
  const CircularChartWidget({
    super.key,
    required this.transactions,
    required DateTime selectedDate,
    required TooltipBehavior tooltipBehavior,
    required AccountEntity account,
    required double totalExpense,
  })  : _selectedDate = selectedDate,
        _tooltipBehavior = tooltipBehavior,
        _account = account,
        _totalExpense = totalExpense;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        HomeSfCircularChart(
            tooltipBehavior: _tooltipBehavior, transactions: transactions),
        SizedBox(
          width: MediaQuery.of(context).size.width * .35,
          child: AutoSizeText(
            NumberFormat.compactCurrency(
              symbol: _account.currency.symbol,
              decimalDigits: 0,
            ).format(_totalExpense),
            textAlign: TextAlign.center,
            minFontSize: 18,
            maxFontSize: 25,
            style: const TextStyle(fontSize: 24),
            maxLines: 1,
          ),
        )
      ],
    );
  }
}

class HomeSfCircularChart extends StatelessWidget {
  const HomeSfCircularChart({
    super.key,
    required TooltipBehavior tooltipBehavior,
    required this.transactions,
  }) : _tooltipBehavior = tooltipBehavior;

  final TooltipBehavior _tooltipBehavior;
  final List<TransactionEntity> transactions;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      tooltipBehavior: _tooltipBehavior,
      series: [
        DoughnutSeries<TransactionEntity, String>(
          // animationDelay: 0,
          // animationDuration: 0,
          explode: true,
          strokeColor: Colors.white,
          strokeWidth: 2,
          innerRadius: "70",
          opacity: 1,
          dataSource: transactions.isEmpty
              ? [
                  TransactionEntity(
                      id: "id",
                      date: DateTime(2023),
                      amount: 1,
                      category: CategoryEntity(
                          id: "id",
                          name: "null",
                          iconData: Icons.abc,
                          color: Colors.grey,
                          isIncome: false,
                          dateTime: DateTime(2023)),
                      iconData: Icons.abc,
                      accountId: "accountId",
                      isIncome: false,
                      color: Colors.grey)
                ]
              : transactions,
          xValueMapper: (TransactionEntity data, index) {
            return data.category.name;
          },
          pointColorMapper: (datum, index) {
            return datum.color;
          },
          yValueMapper: (TransactionEntity data, index) => data.amount,
        ),
      ],
    );
  }
}
