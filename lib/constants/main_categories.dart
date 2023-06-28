// Main Categories
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

import '../features/data/models/category/category_model.dart';

const Uuid uuid = Uuid();
List<CategoryModel> mainCategories = [
  // EXPENSES
  CategoryModel(
      id: uuid.v1(),
      name: "Transportation",
      iconData: FontAwesomeIcons.bus,
      color: Colors.indigoAccent,
      isIncome: false),

  CategoryModel(
      id: uuid.v1(),
      name: "Workout",
      iconData: FontAwesomeIcons.dumbbell,
      color: Colors.green,
      isIncome: false),

  CategoryModel(
      id: uuid.v1(),
      name: "Family",
      iconData: FontAwesomeIcons.baby,
      color: Colors.red,
      isIncome: false),

  CategoryModel(
      id: uuid.v1(),
      name: "Groceries",
      iconData: FontAwesomeIcons.utensils,
      color: Colors.blue,
      isIncome: false),

  CategoryModel(
      id: uuid.v1(),
      name: "Gifts",
      iconData: FontAwesomeIcons.gifts,
      color: Colors.green.shade300,
      isIncome: false),

  CategoryModel(
      id: uuid.v1(),
      name: "Education",
      iconData: FontAwesomeIcons.graduationCap,
      color: Colors.pink,
      isIncome: false),
  CategoryModel(
      id: uuid.v1(),
      name: "Cafe",
      iconData: FontAwesomeIcons.martiniGlassCitrus,
      color: Colors.yellow,
      isIncome: false),

  // INCOME

  CategoryModel(
    id: uuid.v1(),
    name: "Interest",
    iconData: FontAwesomeIcons.buildingColumns,
    color: Colors.green,
    isIncome: true,
  ),

  CategoryModel(
    id: uuid.v1(),
    name: "Gift",
    iconData: FontAwesomeIcons.gift,
    color: Colors.pink.shade400,
    isIncome: true,
  ),

  CategoryModel(
    id: uuid.v1(),
    name: "Paycheck",
    iconData: FontAwesomeIcons.fileInvoiceDollar,
    color: Colors.indigoAccent,
    isIncome: true,
  ),

  CategoryModel(
    id: uuid.v1(),
    name: "Other",
    iconData: FontAwesomeIcons.question,
    color: Colors.grey,
    isIncome: true,
  ),

];