import 'package:coin_saver/features/data/models/currency/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:coin_saver/features/data/models/transaction/transaction_model.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';

import '../../../domain/entities/account/account_entity.dart';

part 'account_model.g.dart';

@HiveType(typeId: 1)
class AccountModel extends AccountEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final AccountType type;
  @HiveField(3)
  final double balance;
  @HiveField(4)
  final CurrencyModel currency;
  @HiveField(5)
  final bool isPrimary;
  @HiveField(6)
  final bool isActive;
  @HiveField(7)
  final String? accountNumber;
  @HiveField(8)
  final String? institution;
  @HiveField(9)
  final OwnershipType ownershipType;
  @HiveField(10)
  final DateTime openingDate;
  @HiveField(11)
  final DateTime? closingDate;
  @HiveField(12)
  final double? interestRate;
  @HiveField(13)
  final double? creditLimit;
  @HiveField(14)
  final int? dueDate;
  @HiveField(15)
  final double? minimumBalance;
  @HiveField(16)
  final List<String>? linkedAccounts;
  @HiveField(17)
  final String? notes;
  @HiveField(18)
  final List<TransactionModel> transactionHistory;
  @HiveField(19)
  final String? monthlyStatement;
  @HiveField(20)
  final PaymentType? paymentType;
  @HiveField(21)
  final IconData iconData;
  @HiveField(22)
  final Color color;

  AccountModel({
    required this.id,
    required this.name,
    required this.iconData,
    required this.type,
    required this.color,
    required this.balance,
    required this.currency,
    required this.isPrimary,
    required this.isActive,
    this.accountNumber,
    this.institution,
    required this.ownershipType,
    required this.openingDate,
    this.closingDate,
    this.interestRate,
    this.creditLimit,
    this.dueDate,
    this.minimumBalance,
    this.linkedAccounts,
    this.notes,
    required this.transactionHistory,
    this.monthlyStatement,
    this.paymentType = PaymentType.cash,
  }) : super(
            id: id,
            name: name,
            iconData: iconData,
            type: type,
            color: color,
            paymentType: paymentType,
            balance: balance,
            currency: currency,
            isPrimary: isPrimary,
            isActive: isActive,
            accountNumber: accountNumber,
            institution: institution,
            ownershipType: ownershipType,
            openingDate: openingDate,
            closingDate: closingDate,
            interestRate: interestRate,
            creditLimit: creditLimit,
            dueDate: dueDate,
            minimumBalance: minimumBalance,
            linkedAccounts: linkedAccounts,
            notes: notes,
            transactionHistory:
                transactionHistory.map((model) => model.toEntity()).toList(),
            monthlyStatement: monthlyStatement,
          );

  @override
  AccountModel copyWith({
    String? id,
    String? name,
    IconData? iconData,
    AccountType? type,
    Color? color,
    PaymentType? paymentType,
    double? balance,
    CurrencyEntity? currency,
    bool? isPrimary,
    bool? isActive,
    String? accountNumber,
    String? institution,
    OwnershipType? ownershipType,
    DateTime? openingDate,
    DateTime? closingDate,
    double? interestRate,
    double? creditLimit,
    int? dueDate,
    double? minimumBalance,
    List<String>? linkedAccounts,
    String? notes,
    List<TransactionEntity>? transactionHistory,
    String? monthlyStatement,
  }) {
    return AccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      type: type ?? this.type,
      color: color ?? this.color,
      paymentType: paymentType ?? this.paymentType,
      balance: balance ?? this.balance,
      currency: currency!=null?CurrencyModel.fromEntity(currency) : this.currency,
      isPrimary: isPrimary ?? this.isPrimary,
      isActive: isActive ?? this.isActive,
      accountNumber: accountNumber ?? this.accountNumber,
      institution: institution ?? this.institution,
      ownershipType: ownershipType ?? this.ownershipType,
      openingDate: openingDate ?? this.openingDate,
      closingDate: closingDate ?? this.closingDate,
      interestRate: interestRate ?? this.interestRate,
      creditLimit: creditLimit ?? this.creditLimit,
      dueDate: dueDate ?? this.dueDate,
      minimumBalance: minimumBalance ?? this.minimumBalance,
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
      notes: notes ?? this.notes,
      transactionHistory: transactionHistory
              ?.map((entity) => TransactionModel.fromEntity(entity))
              .toList() ??
          this.transactionHistory,
      monthlyStatement: monthlyStatement ?? this.monthlyStatement,
    );
  }

 
}
