import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum TransactionCategory {
  food,
  transportation,
  bills,
  // Add more transaction categories as needed
}

enum TransactionFrequency {
  daily,
  weekly,
  monthly,
  // Add more transaction frequencies as needed
}

class TransactionEntity extends Equatable {
  final String id;
  final DateTime date;
  final double amount;
  final CategoryEntity category;
  final IconData iconData;
  final String accountId;
  final bool isIncome;
  final Color color;
  final String? description;
  final List<String>? tags;
  final String? payee;
  final String? currency;
  final String? location;
  final String? receiptImage;
  final String? paymentMethod;
  final bool? isRecurring;
  final String? frequency;
  final DateTime? reminderDate;
  final bool? isCleared;
  final String? notes;
  final List<String>? linkedTransactions;
  final bool? isVoid;
  final bool? isTransfer;

  TransactionEntity({
    required this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.iconData,
    required this.accountId,
    required this.isIncome,
    required this.color,
    this.isTransfer=false,
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
  });

  @override
  List<Object?> get props => [
        id,
        date,
        amount,
        category,
        iconData,
        isTransfer,
        description,
        accountId,
        isIncome,
        color,
        tags,
        payee,
        currency,
        location,
        receiptImage,
        paymentMethod,
        isRecurring,
        frequency,
        reminderDate,
        isCleared,
        notes,
        linkedTransactions,
        isVoid,
      ];
  TransactionEntity copyWith({
    String? id,
    DateTime? date,
    double? amount,
    CategoryEntity? category,
    IconData? iconData,
    String? description,
    String? accountId,
    bool? isIncome,
    bool? isTransfer,
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
    return TransactionEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      iconData: iconData ?? this.iconData,
      description: description ?? this.description,
      accountId: accountId ?? this.accountId,
      isIncome: isIncome ?? this.isIncome,
     isTransfer:isTransfer ?? this.isTransfer,
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
}
