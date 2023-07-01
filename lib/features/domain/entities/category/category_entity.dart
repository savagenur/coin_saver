import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final IconData iconData;
  final Color color;
  final bool isIncome;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconData,
    required this.color,
    required this.isIncome,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        iconData,
        color,
        isIncome,
      ];
  CategoryEntity copyWith({
    String? id,
    String? name,
    IconData? iconData,
    Color? color,
    bool? isIncome,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      color: color ?? this.color,
      isIncome: isIncome ?? this.isIncome,
    );
  }
}
