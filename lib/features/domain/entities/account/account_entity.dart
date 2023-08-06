import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../transaction/transaction_entity.dart';

enum AccountType {
  bankAccount,
  creditCard,
  cash,
  investment,
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
}

class AccountEntity extends Equatable {
  final String id;
  final String name;
  final IconData iconData;
  final Color color;
  final AccountType type;
  final PaymentType? paymentType;
  final double balance;
  final CurrencyEntity currency;
  final bool isPrimary;
  final bool isActive;
  final bool? isTotal;
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
  final String? monthlyStatement;

  const AccountEntity({
    required this.id,
    required this.name,
    required this.iconData,
    required this.color,
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
    this.isTotal=false,
    this.interestRate,
    this.creditLimit,
    this.dueDate,
    this.minimumBalance,
    this.linkedAccounts,
    this.notes,
    this.monthlyStatement,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        iconData,
        type,
        color,
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
        isTotal,
        monthlyStatement,
      ];
  AccountEntity copyWith({
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
    bool? isTotal,
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
    String? monthlyStatement,
  }) {
    return AccountEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      type: type ?? this.type,
      isTotal: isTotal ?? this.isTotal,
      paymentType: paymentType ?? this.paymentType,
      color: color ?? this.color,
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
      monthlyStatement: monthlyStatement ?? this.monthlyStatement,
    );
  }
}
