import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MainTransactionEntity extends Equatable {
  final String id;
  final String accountId;
  final String name;
  final IconData iconData;
  final Color color;
  final double totalAmount;
  final DateTime dateTime;
  final bool isIncome;
  const MainTransactionEntity({
    required this.id,
    required this.accountId,
    required this.name,
    required this.iconData,
    required this.color,
    required this.totalAmount,
    required this.isIncome,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
        id,
        accountId,
        isIncome,
        name,
        iconData,
        color,
        totalAmount,
        dateTime,
      ];
      MainTransactionEntity copyWith({
    String? id,
    String? accountId,
    String? name,
    IconData? iconData,
    Color? color,
    double? totalAmount,
    bool? isIncome,
    DateTime? dateTime,
  }) {
    return MainTransactionEntity(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      color: color ?? this.color,
      isIncome: isIncome ?? this.isIncome,
      totalAmount: totalAmount ?? this.totalAmount,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
