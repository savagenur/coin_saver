import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF3B5998);
// print('Primary Color Hex Code: ${Theme.of(context).primaryColor.value.toRadixString(16).toUpperCase()}');

const List<String> kChartPeriodTitles = [
  "Day",
  "Week",
  "Month",
  "Year",
  "Period",
];

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
