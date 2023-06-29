import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MainTransactionEntity extends Equatable {
  final String id;
  final String name;
  final IconData iconData;
  final Color color;
  final double totalAmount;
  final DateTime dateTime;
  const MainTransactionEntity({
    required this.id,
    required this.name,
    required this.iconData,
    required this.color,
    required this.totalAmount,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        iconData,
        color,
        totalAmount,
        dateTime,
      ];
}