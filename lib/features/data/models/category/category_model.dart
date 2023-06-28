import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../domain/entities/category/category_entity.dart';

part 'category_model.g.dart';

@HiveType(typeId: 3)
class CategoryModel extends CategoryEntity with HiveObjectMixin {
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

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconData,
    required this.color,
    required this.isIncome,
  }) : super(
          id: id,
          name: name,
          iconData: iconData,
          color: color,
          isIncome: isIncome,
        );

  CategoryModel copyWith({
    String? id,
    String? name,
    IconData? iconData,
    Color? color,
    bool? isIncome,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      color: color ?? this.color,
      isIncome: isIncome ?? this.isIncome,
    );
  }
}
