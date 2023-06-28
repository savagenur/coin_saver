import 'package:flutter/material.dart';

// print('Primary Color Hex Code: ${Theme.of(context).primaryColor.value.toRadixString(16).toUpperCase()}');

const List<String> kChartPeriodTitles = [
  "Day",
  "Week",
  "Month",
  "Year",
  "Period",
];

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
