import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'main_transaction_model.g.dart';

@HiveType(typeId: 4)
class MainTransactionModel extends MainTransactionEntity with HiveObjectMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final IconData iconData;

  @HiveField(3)
  final Color color;

  @HiveField(4)
  final double totalAmount;

  @HiveField(5)
  final DateTime dateTime;
  @HiveField(6)
  final String accountId;

  MainTransactionModel({
    required this.id,
    required this.accountId,
    required this.name,
    required this.iconData,
    required this.color,
    required this.totalAmount,
    required this.dateTime,
  }) : super(
          id: id,
          accountId: accountId,
          name: name,
          iconData: iconData,
          color: color,
          totalAmount: totalAmount,
          dateTime: dateTime,
        );

  MainTransactionModel copyWith({
    String? id,
    String? accountId,
    String? name,
    IconData? iconData,
    Color? color,
    double? totalAmount,
    DateTime? dateTime,
  }) {
    return MainTransactionModel(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      color: color ?? this.color,
      totalAmount: totalAmount ?? this.totalAmount,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
