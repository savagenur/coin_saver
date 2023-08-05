import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Main Categories
import 'package:coin_saver/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

import '../features/data/models/category/category_model.dart';


List<CategoryModel> getMainCategories(BuildContext context) {
  Uuid uuid = sl<Uuid>();
  CategoryModel categoryExpenseOther = CategoryModel(
    id: "otherExpense",
    name: AppLocalizations.of(context)!.other,
    iconData: FontAwesomeIcons.question,
    color: Colors.red.shade700,
    isIncome: false,
    dateTime: DateTime.now(),
  );
  CategoryModel categoryIncomeOther = CategoryModel(
    id: "otherIncome",
    name: AppLocalizations.of(context)!.other,
    iconData: FontAwesomeIcons.question,
    color: Colors.grey,
    isIncome: true,
    dateTime: DateTime.now(),
  );
  return [
    // EXPENSES
    CategoryModel(
      id: uuid.v1(),
      name: AppLocalizations.of(context)!.transportation,
      iconData: FontAwesomeIcons.bus,
      color: Colors.indigoAccent,
      isIncome: false,
      dateTime: DateTime.now(),
    ),

    CategoryModel(
      id: uuid.v1(),
      name: AppLocalizations.of(context)!.workout,
      iconData: FontAwesomeIcons.personRunning,
      color: Colors.green,
      isIncome: false,
      dateTime: DateTime.now(),
    ),

    CategoryModel(
      id: uuid.v1(),
      name: AppLocalizations.of(context)!.family,
      iconData: FontAwesomeIcons.baby,
      color: Colors.red,
      isIncome: false,
      dateTime: DateTime.now(),
    ),

    CategoryModel(
      id: uuid.v1(),
      name: AppLocalizations.of(context)!.groceries,
      iconData: FontAwesomeIcons.utensils,
      color: Colors.blue,
      isIncome: false,
      dateTime: DateTime.now(),
    ),

    CategoryModel(
      id: uuid.v1(),
      name: AppLocalizations.of(context)!.gifts,
      iconData: FontAwesomeIcons.gifts,
      color: Colors.green.shade300,
      isIncome: false,
      dateTime: DateTime.now(),
    ),

    CategoryModel(
      id: uuid.v1(),
      name: AppLocalizations.of(context)!.education,
      iconData: FontAwesomeIcons.graduationCap,
      color: Colors.pink,
      isIncome: false,
      dateTime: DateTime.now(),
    ),
    CategoryModel(
      id: uuid.v1(),
      name: AppLocalizations.of(context)!.cafe,
      iconData: FontAwesomeIcons.martiniGlassCitrus,
      color: Colors.yellow.shade900,
      isIncome: false,
      dateTime: DateTime.now(),
    ),
    categoryExpenseOther,

    // INCOME

    CategoryModel(
      id: uuid.v1(),
      name: AppLocalizations.of(context)!.interests,
      iconData: FontAwesomeIcons.buildingColumns,
      color: Colors.green,
      isIncome: true,
      dateTime: DateTime.now(),
    ),

    CategoryModel(
      id: uuid.v1(),
      name: AppLocalizations.of(context)!.gift,
      iconData: FontAwesomeIcons.gift,
      color: Colors.pink.shade400,
      isIncome: true,
      dateTime: DateTime.now(),
    ),

    CategoryModel(
      id: uuid.v1(),
      name: AppLocalizations.of(context)!.paycheck,
      iconData: FontAwesomeIcons.fileInvoiceDollar,
      color: Colors.indigoAccent,
      isIncome: true,
      dateTime: DateTime.now(),
    ),
    categoryIncomeOther,
  ];
}
