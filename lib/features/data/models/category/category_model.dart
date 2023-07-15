import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../domain/entities/category/category_entity.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends CategoryEntity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final IconData iconData;

  @HiveField(3)
  final Color color;
  @HiveField(4)
  final bool isIncome;
  @HiveField(5)
  final DateTime dateTime;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconData,
    required this.color,
    required this.isIncome,
    required this.dateTime,
  }) : super(
          id: id,
          name: name,
          iconData: iconData,
          color: color,
          isIncome: isIncome,
          dateTime: dateTime,
        );

  @override
  CategoryModel copyWith({
    String? id,
    String? name,
    IconData? iconData,
    Color? color,
    bool? isIncome,
    DateTime? dateTime,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      color: color ?? this.color,
      isIncome: isIncome ?? this.isIncome,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
        id: id,
        name: name,
        iconData: iconData,
        color: color,
        isIncome: isIncome,
        dateTime: dateTime);
  }

  static CategoryModel fromEntity(CategoryEntity entity) {
    return CategoryModel(
        id: entity.id,
        name: entity.name,
        iconData: entity.iconData,
        color: entity.color,
        isIncome: entity.isIncome,
        dateTime: entity.dateTime);
  }
}
