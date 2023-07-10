// Main Categories
import 'package:coin_saver/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

import '../features/data/models/category/category_model.dart';

 Uuid uuid = getIt<Uuid>();
List<CategoryModel> mainCategories = [
  // EXPENSES
  CategoryModel(
    id: uuid.v1(),
    name: "Transportation",
    iconData: FontAwesomeIcons.bus,
    color: Colors.indigoAccent,
    isIncome: false,
    dateTime: DateTime.now(),
  ),

  CategoryModel(
    id: uuid.v1(),
    name: "Workout",
    iconData: FontAwesomeIcons.personRunning,
    color: Colors.green,
    isIncome: false,
    dateTime: DateTime.now(),
  ),

  CategoryModel(
    id: uuid.v1(),
    name: "Family",
    iconData: FontAwesomeIcons.baby,
    color: Colors.red,
    isIncome: false,
    dateTime: DateTime.now(),
  ),

  CategoryModel(
    id: uuid.v1(),
    name: "Groceries",
    iconData: FontAwesomeIcons.utensils,
    color: Colors.blue,
    isIncome: false,
    dateTime: DateTime.now(),
  ),

  CategoryModel(
    id: uuid.v1(),
    name: "Gifts",
    iconData: FontAwesomeIcons.gifts,
    color: Colors.green.shade300,
    isIncome: false,
    dateTime: DateTime.now(),
  ),

  CategoryModel(
    id: uuid.v1(),
    name: "Education",
    iconData: FontAwesomeIcons.graduationCap,
    color: Colors.pink,
    isIncome: false,
    dateTime: DateTime.now(),
  ),
  CategoryModel(
    id: uuid.v1(),
    name: "Cafe",
    iconData: FontAwesomeIcons.martiniGlassCitrus,
    color: Colors.yellow.shade900,
    isIncome: false,
    dateTime: DateTime.now(),
  ),

  // INCOME

  CategoryModel(
    id: uuid.v1(),
    name: "Interest",
    iconData: FontAwesomeIcons.buildingColumns,
    color: Colors.green,
    isIncome: true, dateTime: DateTime.now(),
  ),

  CategoryModel(
    id: uuid.v1(),
    name: "Gift",
    iconData: FontAwesomeIcons.gift,
    color: Colors.pink.shade400,
    isIncome: true, dateTime: DateTime.now(),
  ),

  CategoryModel(
    id: uuid.v1(),
    name: "Paycheck",
    iconData: FontAwesomeIcons.fileInvoiceDollar,
    color: Colors.indigoAccent,
    isIncome: true, dateTime: DateTime.now(),
  ),

  CategoryModel(
    id: uuid.v1(),
    name: "Other",
    iconData: FontAwesomeIcons.question,
    color: Colors.grey,
    isIncome: true, dateTime: DateTime.now(),
  ),
];
