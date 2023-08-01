import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';

class TimeGroupModel {
  final DateTime start;
  final DateTime end;
  final List<TransactionEntity> transactions;
  final double income;
  final double expense;
  final double profit;
  final double loss;

  TimeGroupModel({
    required this.start,
    required this.end,
    required this.transactions,
    required this.income,
    required this.expense,
    required this.profit,
    required this.loss,
  });
}
