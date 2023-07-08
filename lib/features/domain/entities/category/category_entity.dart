import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final IconData iconData;
  final Color color;
  final bool isIncome;
  final DateTime dateTime;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconData,
    required this.color,
    required this.isIncome,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        iconData,
        color,
        isIncome,
        dateTime,
      ];
  CategoryEntity copyWith({
    String? id,
    String? name,
    IconData? iconData,
    Color? color,
    bool? isIncome,
    DateTime? dateTime,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      color: color ?? this.color,
      isIncome: isIncome ?? this.isIncome,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
