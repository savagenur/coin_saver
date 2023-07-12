import 'package:coin_saver/features/data/models/category/category_model.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../domain/entities/transaction/transaction_entity.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 5)
class TransactionModel extends TransactionEntity with HiveObjectMixin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final CategoryModel category;
  @HiveField(4)
  final String? description;
  @HiveField(5)
  final String accountId;
  @HiveField(6)
  final bool isIncome;
  @HiveField(7)
  final List<String>? tags;
  @HiveField(8)
  final String? payee;
  @HiveField(9)
  final String? currency;
  @HiveField(10)
  final String? location;
  @HiveField(11)
  final String? receiptImage;
  @HiveField(12)
  final String? paymentMethod;
  @HiveField(13)
  final bool? isRecurring;
  @HiveField(14)
  final String? frequency;
  @HiveField(15)
  final DateTime? reminderDate;
  @HiveField(16)
  final bool? isCleared;
  @HiveField(17)
  final String? notes;
  @HiveField(18)
  final List<String>? linkedTransactions;
  @HiveField(19)
  final bool? isVoid;
  @HiveField(20)
  final Color color;
  @HiveField(21)
  final IconData iconData;

  TransactionModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.iconData,
    required this.accountId,
    required this.isIncome,
    required this.color,
    this.description,
    this.tags,
    this.payee,
    this.currency,
    this.location,
    this.receiptImage,
    this.paymentMethod,
    this.isRecurring,
    this.frequency,
    this.reminderDate,
    this.isCleared,
    this.notes,
    this.linkedTransactions,
    this.isVoid,
  }) : super(
          id: id,
          date: date,
          amount: amount,
          category: category,
          iconData: iconData,
          description: description,
          accountId: accountId,
          isIncome: isIncome,
          color: color,
          tags: tags,
          payee: payee,
          currency: currency,
          location: location,
          receiptImage: receiptImage,
          paymentMethod: paymentMethod,
          isRecurring: isRecurring,
          frequency: frequency,
          reminderDate: reminderDate,
          isCleared: isCleared,
          notes: notes,
          linkedTransactions: linkedTransactions,
          isVoid: isVoid,
        );

  @override
  TransactionModel copyWith({
    String? id,
    DateTime? date,
    double? amount,
    CategoryEntity? category,
    IconData? iconData,
    String? description,
    String? accountId,
    bool? isIncome,
    Color? color,
    List<String>? tags,
    String? payee,
    String? currency,
    String? location,
    String? receiptImage,
    String? paymentMethod,
    bool? isRecurring,
    String? frequency,
    DateTime? reminderDate,
    bool? isCleared,
    String? notes,
    List<String>? linkedTransactions,
    bool? isVoid,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      category:category != null ? CategoryModel.fromEntity(category) : this.category,
      iconData: iconData ?? this.iconData,
      description: description ?? this.description,
      accountId: accountId ?? this.accountId,
      isIncome: isIncome ?? this.isIncome,
      color: color ?? this.color,
      tags: tags ?? this.tags,
      payee: payee ?? this.payee,
      currency: currency ?? this.currency,
      location: location ?? this.location,
      receiptImage: receiptImage ?? this.receiptImage,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isRecurring: isRecurring ?? this.isRecurring,
      frequency: frequency ?? this.frequency,
      reminderDate: reminderDate ?? this.reminderDate,
      isCleared: isCleared ?? this.isCleared,
      notes: notes ?? this.notes,
      linkedTransactions: linkedTransactions ?? this.linkedTransactions,
      isVoid: isVoid ?? this.isVoid,
    );
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      date: date,
      amount: amount,
      category: category,
      iconData: iconData,
      accountId: accountId,
      isIncome: isIncome,
      color: color,
      currency: currency,
      description: description,
      frequency: frequency,
      isCleared: isCleared,
      isRecurring: isRecurring,
      isVoid: isVoid,
      linkedTransactions: linkedTransactions,
      location: location,
      notes: notes,
      payee: payee,
      paymentMethod: paymentMethod,
      receiptImage: receiptImage,
      reminderDate: reminderDate,
      tags: tags,
    );
  }

  static TransactionModel fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      date: entity.date,
      amount: entity.amount,
      category: CategoryModel.fromEntity(entity.category),
      iconData: entity.iconData,
      accountId: entity.accountId,
      isIncome: entity.isIncome,
      color: entity.color,
      currency: entity.currency,
      description: entity.description,
      frequency: entity.frequency,
      isCleared: entity.isCleared,
      isRecurring: entity.isRecurring,
      isVoid: entity.isVoid,
      linkedTransactions: entity.linkedTransactions,
      location: entity.location,
      notes: entity.notes,
      payee: entity.payee,
      paymentMethod: entity.paymentMethod,
      receiptImage: entity.receiptImage,
      reminderDate: entity.reminderDate,
      tags: entity.tags,
    );
  }
}
