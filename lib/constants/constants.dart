import 'package:flutter/material.dart';

// print('Primary Color Hex Code: ${Theme.of(context).primaryColor.value.toRadixString(16).toUpperCase()}');

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
  static const String homePage = "homePage";
  static const String addTransactionPage = "addTransactionPage";
  static const String catalogIconsPage = "catalogIconsPage";
  static const String colorsPage = "colorsPage";
  static const String historyPage = "historyPage";
  static const String addCategoryPage = "addCategoryPage";
  static const String createCategoryPage = "createCategoryPage";
  static const String transactionsPage = "transactionsPage";
  static const String mainTransactionPage = "mainTransactionPage";
  static const String transactionDetailPage = "transactionDetailPage";
}
