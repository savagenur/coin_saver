import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../domain/entities/account/account_entity.dart';
import '../../../../domain/entities/main_transaction/main_transaction_entity.dart';
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
        transactions.isEmpty
            ? EmptySfCircularChart(selectedDate: _selectedDate)
            : HomeSfCircularChart(
                tooltipBehavior: _tooltipBehavior, transactions: transactions),
        SizedBox(
          width: MediaQuery.of(context).size.width * .35,
          child: AutoSizeText(
            NumberFormat.currency(symbol: _account.currency.symbol,decimalDigits: 0, )
                .format(_totalExpense),
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

class EmptySfCircularChart extends StatelessWidget {
  const EmptySfCircularChart({
    super.key,
    required DateTime selectedDate,
  }) : _selectedDate = selectedDate;

  final DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      series: [
        DoughnutSeries<MainTransactionEntity, String>(
          animationDuration: 0,
          strokeColor: Colors.white,
          strokeWidth: 2,
          innerRadius: "70",
          opacity: 1,
          dataSource: [
            MainTransactionEntity(
                id: "id",
                accountId: "accountId",
                name: "name",
                iconData: Icons.data_array,
                color: Colors.grey,
                isIncome: false,
                totalAmount: 1,
                dateTime: _selectedDate)
          ],
          xValueMapper: (MainTransactionEntity data, index) {
            return data.name;
          },
          pointColorMapper: (datum, index) {
            return Colors.grey;
          },
          yValueMapper: (MainTransactionEntity data, index) => 1,
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
          animationDelay: 0,
          animationDuration: 0,
          explode: true,
          strokeColor: Colors.white,
          strokeWidth: 2,
          innerRadius: "70",
          opacity: 1,
          dataSource: transactions,
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
