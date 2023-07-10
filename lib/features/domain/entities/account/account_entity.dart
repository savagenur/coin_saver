import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../transaction/transaction_entity.dart';

enum AccountType {
  bankAccount,
  creditCard,
  cash,
  investment,
  // Add more account types as needed
}

enum PaymentType {
  cash,
  debitCard,
  creditCard,
  bankTransfer,
  voucher,
  mobilePayment,
  webPayment,
}

enum OwnershipType {
  individual,
  joint,
  business,
  // Add more ownership types as needed
}

class AccountEntity extends Equatable {
  final String id;
  final String name;
  final IconData iconData;
  final AccountType type;
  final PaymentType? paymentType;
  final double balance;
  final CurrencyEntity currency;
  final bool isPrimary;
  final bool isActive;
  final String? accountNumber;
  final String? institution;
  final OwnershipType ownershipType;
  final DateTime openingDate;
  final DateTime? closingDate;
  final double? interestRate;
  final double? creditLimit;
  final int? dueDate;
  final double? minimumBalance;
  final List<String>? linkedAccounts;
  final String? notes;
  final List<TransactionEntity> transactionHistory;
  final String? monthlyStatement;

  const AccountEntity({
    required this.id,
    required this.name,
    required this.iconData,
    required this.type,
    this.paymentType,
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
  });

  @override
  List<Object?> get props => [
        id,
        name,
        iconData,
        type,
        paymentType,
        balance,
        currency,
        isPrimary,
        isActive,
        accountNumber,
        institution,
        ownershipType,
        openingDate,
        closingDate,
        interestRate,
        creditLimit,
        dueDate,
        minimumBalance,
        linkedAccounts,
        notes,
        transactionHistory,
        monthlyStatement,
      ];
  AccountEntity copyWith({
    String? id,
    String? name,
    IconData? iconData,
    AccountType? type,
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
    return AccountEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      type: type ?? this.type,
      paymentType: paymentType ?? this.paymentType,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
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
      transactionHistory: transactionHistory ?? this.transactionHistory,
      monthlyStatement: monthlyStatement ?? this.monthlyStatement,
    );
  }
}
