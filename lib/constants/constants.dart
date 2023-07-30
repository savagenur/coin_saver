import 'package:coin_saver/features/data/models/category/category_model.dart';
import 'package:coin_saver/features/data/models/transaction/transaction_model.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:flutter/material.dart';

import '../features/data/models/account/account_model.dart';

// print('Primary Color Hex Code: ${Theme.of(context).primaryColor.value.toRadixString(16).toUpperCase()}');

AccountModel accountError = AccountModel(
    id: "null",
    name: "null",
    iconData: Icons.abc,
    color: Colors.green,
    type: AccountType.cash,
    balance: 0,
    currency:
        const CurrencyEntity(code: "code", name: "name", symbol: "symbol"),
    isPrimary: false,
    isActive: true,
    ownershipType: OwnershipType.business,
    openingDate: DateTime(2023),
    transactionHistory: []);
TransactionModel transactionError = TransactionModel(
    id: 'null',
    date: DateTime.now(),
    amount: 0,
    category: CategoryModel(
        id: "null",
        name: "null",
        iconData: Icons.data_array,
        color: Colors.black,
        isIncome: false,
        dateTime: DateTime.now()),
    iconData: Icons.abc,
    accountId: "accountId",
    isIncome: false,
    color: Colors.black);
const List<String> kChartPeriodTitles = [
  "Day",
  "Week",
  "Month",
  "Year",
  "Period",
];

const Color secondaryColor = Colors.black38;

// SizedBox
Widget sizeVer(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sizeHor(double width) {
  return SizedBox(
    width: width,
  );
}

class PageConst {
  static const String homePage = "/homePage";
  static const String addTransactionPage = "/addTransactionPage";
  static const String catalogIconsPage = "/catalogIconsPage";
  static const String colorsPage = "/colorsPage";
  static const String historyPage = "/historyPage";
  static const String addCategoryPage = "/addCategoryPage";
  static const String createCategoryPage = "/createCategoryPage";
  static const String transactionsPage = "/transactionsPage";
  static const String mainTransactionPage = "/mainTransactionPage";
  static const String transactionDetailPage = "/transactionDetailPage";
  static const String accountsPage = "/accountsPage";
  static const String cRUDAccountPage = "/cRUDAccountPage";
  static const String createTransferPage = "/createTransferPage";
  static const String transferHistoryPage = "/transferHistoryPage";
  static const String transferDetailPage = "/transferDetailPage";
  static const String categoriesPage = "/categoriesPage";
}

class BoxConst {
  static const String accounts = "accounts";
  static const String colors = "colors";
  static const String currency = "currency";
  static const String categories = "categories";
  static const String mainTransactions = "mainTransactions";
  static const String exchangeRates = "exchangeRates";
}
