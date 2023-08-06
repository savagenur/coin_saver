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
  final AccountEntity _account;
  final double _totalExpense;
  const CircularChartWidget({
    super.key,
    required this.transactions,
    required DateTime selectedDate,
    required AccountEntity account,
    required double totalExpense,
  })  : _selectedDate = selectedDate,
        _account = account,
        _totalExpense = totalExpense;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        HomeSfCircularChart(transactions: transactions, account: _account),
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

class HomeSfCircularChart extends StatefulWidget {
  const HomeSfCircularChart({
    super.key,
    required this.transactions,
    required this.account,
  });

  final List<TransactionEntity> transactions;
  final AccountEntity account;

  @override
  State<HomeSfCircularChart> createState() => _HomeSfCircularChartState();
}

class _HomeSfCircularChartState extends State<HomeSfCircularChart> {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      tooltipBehavior: TooltipBehavior(
              animationDuration: 1,
              enable: true,
              textStyle: const TextStyle(fontSize: 16),
              format: 'point.x - ${widget.account.currency.symbol}point.y',
            ),
      series: [
        DoughnutSeries<TransactionEntity, String>(
          // animationDelay: 0,
          // animationDuration: 0,
          explode: true,
          strokeColor: Colors.white,
          strokeWidth: 2,
          innerRadius: "70",
          opacity: 1,
          dataSource: widget.transactions.isEmpty
              ? [
                  TransactionEntity(
                      id: "id",
                      date: DateTime(2023),
                      amount: 1,
                      category: CategoryEntity(
                          id: "null",
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
              : widget.transactions,

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
