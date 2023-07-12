import 'package:coin_saver/constants/colors.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/constants/currencies.dart';
import 'package:coin_saver/constants/main_categories.dart';
import 'package:coin_saver/features/data/datasources/local_datasource/base_hive_local_data_source.dart';
import 'package:coin_saver/features/data/models/account/account_model.dart';
import 'package:coin_saver/features/data/models/category/category_model.dart';
import 'package:coin_saver/features/data/models/currency/currency_model.dart';
import 'package:coin_saver/features/data/models/main_transaction/main_transaction_model.dart';
import 'package:coin_saver/features/data/models/transaction/transaction_model.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/account_type.dart';
import '../../models/color.dart';
import '../../models/icon_data.dart';
import '../../models/ownership_type.dart';
import '../../models/payment_type.dart';

class HiveLocalDataSource implements BaseHiveLocalDataSource {
  final Uuid uuid = getIt<Uuid>();

  // * Initialization Hive
  @override
  Future<void> initHive() async {
    Hive.registerAdapter<AccountType>(AccountTypeAdapter());
    Hive.registerAdapter<OwnershipType>(OwnershipTypeAdapter());
    Hive.registerAdapter<PaymentType>(PaymentTypeAdapter());
    Hive.registerAdapter<CategoryModel>(CategoryModelAdapter());
    Hive.registerAdapter<CurrencyModel>(CurrencyModelAdapter());
    Hive.registerAdapter<AccountModel>(AccountModelAdapter());
    Hive.registerAdapter<MainTransactionModel>(MainTransactionModelAdapter());
    Hive.registerAdapter<IconData>(IconDataAdapter());
    Hive.registerAdapter<Color>(ColorAdapter());
    Hive.registerAdapter<TransactionModel>(TransactionModelAdapter());

    Box accountsBox = await Hive.openBox<AccountModel>(BoxConst.accounts);
    Box currencyBox = await Hive.openBox<CurrencyModel>(BoxConst.currency);
    Box categoriesBox = await Hive.openBox<CategoryModel>(BoxConst.categories);
    Box mainTransactionBox =
        await Hive.openBox<MainTransactionModel>(BoxConst.mainTransactions);
    Box colorsBox = await Hive.openBox<Color>(BoxConst.colors);

    if (currencyBox.isEmpty) {
      await colorsBox.addAll(mainColors);

      // Currency
      Map<String, CurrencyModel> currencyMap = {};
      for (var currency in currencies) {
        currencyMap[currency.code] = currency;
      }
      await currencyBox.putAll(currencyMap);
      // MainCategories
      Map<String, CategoryModel> categoryMap = {};
      for (var category in mainCategories) {
        categoryMap[category.id] = category;
      }
      await categoriesBox.putAll(categoryMap);

      // Accounts
      String accountId = uuid.v1();
      await accountsBox.put(
          "total",
          AccountModel(
              id: "total",
              name: "Total",
              iconData: FontAwesomeIcons.coins,
              type: AccountType.cash,
              color: Colors.blue.shade800,
              balance: 0,
              currency: currencyBox.get("KGS"),
              isPrimary: false,
              isActive: true,
              ownershipType: OwnershipType.joint,
              openingDate: DateTime.now(),
              transactionHistory: const []));
      await accountsBox.put(
          "main",
          AccountModel(
              id: "main",
              name: "Main",
              iconData: FontAwesomeIcons.coins,
              type: AccountType.cash,
              color: Colors.blue.shade800,
              balance: 0,
              currency: currencyBox.get("KGS"),
              isPrimary: true,
              isActive: true,
              ownershipType: OwnershipType.individual,
              openingDate: DateTime.now(),
              transactionHistory: const []));
      await accountsBox.put(
          accountId,
          AccountModel(
              id: accountId,
              name: "Optima card",
              iconData: FontAwesomeIcons.moneyBill,
              type: AccountType.cash,
              color: Colors.green.shade800,
              balance: 0,
              currency: currencyBox.get("KGS"),
              isPrimary: false,
              isActive: true,
              ownershipType: OwnershipType.individual,
              openingDate: DateTime.now(),
              transactionHistory: const []));
      
    }
  }

  // * Account
  @override
  Future<void> putAccounts(List<AccountEntity> accounts) async {
    final Box accountsBox = await Hive.openBox<AccountModel>(BoxConst.accounts);
    await accountsBox.clear();
    await accountsBox.add(accounts);
  }

  @override
  Future<void> setPrimaryAccount(String accountId) async {
    final Box accountsBox = await Hive.openBox<AccountModel>(BoxConst.accounts);
    final accounts = accountsBox.values.toList() as List<AccountModel>;
    final Map<String, AccountModel> map = {};
    final primaryAccount = accounts
        .firstWhere(
          (account) => account.isPrimary,
        )
        .copyWith(isPrimary: false);

    final desiredAccount = accounts
        .firstWhere((account) => account.id == accountId)
        .copyWith(isPrimary: true);
    map[primaryAccount.id] = primaryAccount;
    map[desiredAccount.id] = desiredAccount;
    await accountsBox.putAll(map);
  }

  @override
  Future<void> createAccount(AccountEntity accountEntity) async {
    Box box = await Hive.openBox<AccountModel>(BoxConst.accounts);
    await box.put(
      accountEntity.id,
      AccountModel(
          id: accountEntity.id,
          name: accountEntity.name,
          iconData: accountEntity.iconData,
          type: accountEntity.type,
          color: accountEntity.color,
          balance: accountEntity.balance,
          currency: CurrencyModel.fromEntity(accountEntity.currency),
          isPrimary: true,
          isActive: true,
          ownershipType: accountEntity.ownershipType,
          openingDate: accountEntity.openingDate,
          transactionHistory: accountEntity.transactionHistory
              .map((e) => TransactionModel.fromEntity(e))
              .toList()),
    );
  }

  @override
  Future<void> deleteAccount(String id) async {
    Box box = await Hive.openBox<AccountModel>(BoxConst.accounts);
    await box.delete(id);
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    Box box = await Hive.openBox<AccountModel>(BoxConst.accounts);
    return box.values.toList().cast<AccountModel>();
  }

  @override
  Future<void> updateAccount(AccountEntity accountEntity) async {
    Box accountsBox = await Hive.openBox<AccountModel>(BoxConst.accounts);

    await accountsBox.put(
        accountEntity.id,
        AccountModel(
            id: accountEntity.id,
            name: accountEntity.name,
            iconData: accountEntity.iconData,
            type: accountEntity.type,
            color: accountEntity.color,
            balance: accountEntity.balance,
            currency: CurrencyModel.fromEntity(accountEntity.currency),
            isPrimary: accountEntity.isPrimary,
            isActive: accountEntity.isActive,
            ownershipType: accountEntity.ownershipType,
            openingDate: accountEntity.openingDate,
            transactionHistory: accountEntity.transactionHistory
                .map((e) => TransactionModel.fromEntity(e))
                .toList()));
  }

  @override
  Future<void> selectAccount(
      AccountEntity accountEntity, List<AccountEntity> accounts) async {
    Box accountsBox = await Hive.openBox<AccountModel>(BoxConst.accounts);

    List<AccountModel> accountModels = [];
    for (var account in accounts) {
      if (account.id == accountEntity.id) {
        accountModels.add(AccountModel(
            id: account.id,
            name: account.name,
            iconData: account.iconData,
            type: account.type,
            color: account.color,
            balance: account.balance,
            currency: CurrencyModel.fromEntity(account.currency),
            isPrimary: true,
            isActive: account.isActive,
            ownershipType: account.ownershipType,
            openingDate: account.openingDate,
            transactionHistory: accountEntity.transactionHistory
                .map((e) => TransactionModel.fromEntity(e))
                .toList()));
      } else {
        accountModels.add(AccountModel(
            id: account.id,
            name: account.name,
            iconData: account.iconData,
            type: account.type,
            color: account.color,
            balance: account.balance,
            currency: CurrencyModel.fromEntity(account.currency),
            isPrimary: false,
            isActive: account.isActive,
            ownershipType: account.ownershipType,
            openingDate: account.openingDate,
            transactionHistory: accountEntity.transactionHistory
                .map((e) => TransactionModel.fromEntity(e))
                .toList()));
      }
      await accountsBox.clear();
    }
    for (var element in accountModels) {
      await accountsBox.put(element.id, element);
    }
  }

  // * Transaction
  @override
  Future<void> addTransaction({
    required AccountEntity accountEntity,
    required TransactionEntity transactionEntity,
    required bool isIncome,
    required double amount,
  }) async {
    final Box accountsBox = await Hive.openBox<AccountModel>(BoxConst.accounts);

    TransactionModel transaction = TransactionModel(
      id: transactionEntity.id,
      date: transactionEntity.date,
      amount: amount,
      category: CategoryModel.fromEntity(transactionEntity.category),
      iconData: transactionEntity.iconData,
      accountId: accountEntity.id,
      isIncome: isIncome,
      color: transactionEntity.color,
    );

    AccountModel account = AccountModel(
      id: accountEntity.id,
      name: accountEntity.name,
      iconData: accountEntity.iconData,
      type: accountEntity.type,
      color: accountEntity.color,
      balance: isIncome
          ? accountEntity.balance + amount
          : accountEntity.balance - amount,
      currency: CurrencyModel.fromEntity(accountEntity.currency),
      isPrimary: true,
      isActive: accountEntity.isActive,
      ownershipType: accountEntity.ownershipType,
      openingDate: accountEntity.openingDate,
      transactionHistory: accountEntity.transactionHistory
          .map((e) => TransactionModel.fromEntity(e))
          .toList()
        ..add(transaction),
    );
    await accountsBox.put(accountEntity.id, account);
  }

  Future<void> deleteTransaction({
    required TransactionEntity transactionEntity,
    required AccountEntity accountEntity,
  }) async {
    final Box accountsBox = await Hive.openBox<AccountModel>(BoxConst.accounts);

    AccountModel account = AccountModel(
      id: accountEntity.id,
      name: accountEntity.name,
      iconData: accountEntity.iconData,
      type: accountEntity.type,
      color: accountEntity.color,
      balance: transactionEntity.isIncome
          ? accountEntity.balance - transactionEntity.amount
          : accountEntity.balance + transactionEntity.amount,
      currency: CurrencyModel.fromEntity(accountEntity.currency),
      isPrimary: true,
      isActive: accountEntity.isActive,
      ownershipType: accountEntity.ownershipType,
      openingDate: accountEntity.openingDate,
      transactionHistory: accountEntity.transactionHistory
          .map((e) => TransactionModel.fromEntity(e))
          .toList()
        ..remove(transactionEntity),
    );
    await accountsBox.put(accountEntity.id, account);
  }

  // * Currency
  @override
  Future<void> createCurrency(CurrencyEntity currencyEntity) async {
    Box box = await Hive.openBox<CurrencyModel>(BoxConst.currency);
    await box.put(
        0,
        CurrencyModel(
            code: currencyEntity.code,
            name: currencyEntity.name,
            symbol: currencyEntity.symbol));
  }

  @override
  Future<CurrencyEntity> getCurrency() async {
    Box box = await Hive.openBox<CurrencyModel>(BoxConst.currency);
    return box.getAt(0);
  }

  @override
  Future<void> updateCurrency(CurrencyEntity currencyEntity) async {
    Box box = await Hive.openBox<CurrencyModel>(BoxConst.currency);
    await box.put(
        0,
        CurrencyModel(
            code: currencyEntity.code,
            name: currencyEntity.name,
            symbol: currencyEntity.symbol));
  }

  // * MainTransaction
  @override
  Future<void> createMainTransaction(
      MainTransactionEntity mainTransactionEntity) async {
    Box box =
        await Hive.openBox<MainTransactionModel>(BoxConst.mainTransactions);
    List<MainTransactionModel> mainTransactions =
        box.values.toList() as List<MainTransactionModel>;
    // name + accountId + dateTime = id

    List mainTransactionList = mainTransactions
        .where(
          (mainTransaction) =>
              mainTransaction.name == mainTransactionEntity.name &&
              mainTransaction.accountId == mainTransactionEntity.accountId &&
              DateFormat.yMMMd().format(mainTransaction.dateTime) ==
                  DateFormat.yMMMd().format(mainTransactionEntity.dateTime),
        )
        .toList();
    if (mainTransactionList.isEmpty) {
      await box.put(
        mainTransactionEntity.id,
        MainTransactionModel(
            id: mainTransactionEntity.id,
            accountId: mainTransactionEntity.accountId,
            name: mainTransactionEntity.name,
            iconData: mainTransactionEntity.iconData,
            color: mainTransactionEntity.color,
            isIncome: mainTransactionEntity.isIncome,
            totalAmount: mainTransactionEntity.totalAmount,
            dateTime: mainTransactionEntity.dateTime),
      );
    } else {
      var mainTransaction = mainTransactionList.first;
      await box.put(
        mainTransaction.id,
        MainTransactionModel(
            id: mainTransaction.id,
            accountId: mainTransactionEntity.accountId,
            name: mainTransactionEntity.name,
            iconData: mainTransactionEntity.iconData,
            color: mainTransactionEntity.color,
            isIncome: mainTransactionEntity.isIncome,
            totalAmount:
                mainTransaction.totalAmount + mainTransactionEntity.totalAmount,
            dateTime: mainTransactionEntity.dateTime),
      );
    }
  }

  @override
  Future<void> deleteMainTransaction(
      TransactionEntity transactionEntity) async {
    final mainTransactionBox =
        await Hive.openBox<MainTransactionModel>(BoxConst.mainTransactions);

    MainTransactionModel mainTransaction = mainTransactionBox.values.firstWhere(
      (mainTransaction) =>
          mainTransaction.name == transactionEntity.category &&
          mainTransaction.isIncome == transactionEntity.isIncome &&
          mainTransaction.accountId == transactionEntity.accountId &&
          DateFormat.yMd().format(mainTransaction.dateTime) ==
              DateFormat.yMd().format(transactionEntity.date),
    );
    double totalAmount = mainTransaction.totalAmount - transactionEntity.amount;
    if (totalAmount <= 0) {
      await mainTransactionBox.delete(mainTransaction.id);
    } else {
      await mainTransactionBox.put(mainTransaction.id,
          mainTransaction.copyWith(totalAmount: totalAmount));
    }
  }

  @override
  Future<List<MainTransactionEntity>> getMainTransactions() async {
    Box box =
        await Hive.openBox<MainTransactionModel>(BoxConst.mainTransactions);
    return box.values.toList().cast<MainTransactionModel>();
  }

  @override
  Future<void> updateMainTransaction(
      String oldKey, MainTransactionEntity mainTransactionEntity) async {
    Box box =
        await Hive.openBox<MainTransactionModel>(BoxConst.mainTransactions);
    MainTransactionModel oldMainTransactionModel = await box.get(oldKey);
    await box.put(
        mainTransactionEntity.name,
        MainTransactionModel(
            id: mainTransactionEntity.name,
            accountId: mainTransactionEntity.accountId,
            name: mainTransactionEntity.name,
            iconData: mainTransactionEntity.iconData,
            color: mainTransactionEntity.color,
            isIncome: mainTransactionEntity.isIncome,
            totalAmount: oldMainTransactionModel.totalAmount,
            dateTime: oldMainTransactionModel.dateTime));
    await box.delete(oldKey);
  }

  // * Category
  @override
  Future<void> createCategory(CategoryEntity categoryEntity) async {
    Box box = await Hive.openBox<CategoryModel>(BoxConst.categories);
    CategoryModel categoryModel = CategoryModel(
      id: categoryEntity.id,
      name: categoryEntity.name,
      iconData: categoryEntity.iconData,
      color: categoryEntity.color,
      isIncome: categoryEntity.isIncome,
      dateTime: categoryEntity.dateTime,
    );
    await box.put(categoryEntity.id, categoryModel);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    Box box = await Hive.openBox<CategoryModel>(BoxConst.categories);
    await box.delete(categoryId);
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    Box box = await Hive.openBox<CategoryModel>(BoxConst.categories);

    List<CategoryEntity> categories = box.values.toList().cast<CategoryModel>();
    return categories;
  }

  @override
  Future<void> updateCategory(int index, CategoryEntity categoryEntity) async {
    Box box = await Hive.openBox<CategoryModel>(BoxConst.categories);
    CategoryModel categoryModel = CategoryModel(
      id: categoryEntity.id,
      name: categoryEntity.name,
      iconData: categoryEntity.iconData,
      color: categoryEntity.color,
      isIncome: categoryEntity.isIncome,
      dateTime: categoryEntity.dateTime,
    );

    await box.put(
      categoryEntity.id,
      categoryModel,
    );
  }

  // * Selected Date MainTransaction
  @override
  List<MainTransactionEntity> getMainTransactionsForToday() {
    Box box = Hive.box<MainTransactionModel>(BoxConst.mainTransactions);
    final List<MainTransactionModel> totalTransactions =
        box.values.toList().cast<MainTransactionModel>();
    final selectedDate = DateTime.now();
    return totalTransactions.where((transaction) {
      return transaction.dateTime.day == selectedDate.day &&
          transaction.dateTime.month == selectedDate.month &&
          transaction.dateTime.year == selectedDate.year;
    }).toList();
  }

  @override
  List<MainTransactionEntity> fetchMainTransactionsForDay(DateTime selectedDate,
      List<MainTransactionEntity> totalMainTransactions) {
    return totalMainTransactions.where((mainTransaction) {
      return mainTransaction.dateTime.day == selectedDate.day &&
          mainTransaction.dateTime.month == selectedDate.month &&
          mainTransaction.dateTime.year == selectedDate.year;
    }).toList();
  }

  @override
  List<MainTransactionEntity> fetchMainTransactionsForMonth(
      DateTime selectedDate,
      List<MainTransactionEntity> totalMainTransactions) {
    final startOfMonth = DateTime(selectedDate.year, selectedDate.month)
        .subtract(const Duration(days: 1));
    final endOfMonth = DateTime(selectedDate.year, selectedDate.month + 1)
        .subtract(const Duration(days: 0));
    List<MainTransactionEntity> monthTransactions =
        totalMainTransactions.where((mainTransaction) {
      DateTime transactionDate = mainTransaction.dateTime;
      return transactionDate.isAfter(startOfMonth) &&
          transactionDate.isBefore(endOfMonth);
    }).toList();

    return monthTransactions;
  }

  @override
  List<MainTransactionEntity> fetchMainTransactionsForWeek(
      DateTime selectedDate,
      List<MainTransactionEntity> totalMainTransactions) {
    final startOfWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    List<MainTransactionEntity> weekTransactions =
        totalMainTransactions.where((mainTransaction) {
      DateTime mainTransactionDate = mainTransaction.dateTime;
      return mainTransactionDate
              .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          mainTransactionDate.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();

    return weekTransactions;
  }

  @override
  List<MainTransactionEntity> fetchMainTransactionsForYear(
      DateTime selectedDate,
      List<MainTransactionEntity> totalMainTransactions) {
    List<MainTransactionEntity> yearTransactions =
        totalMainTransactions.where((mainTransaction) {
      int transactionYear = mainTransaction.dateTime.year;
      return transactionYear == selectedDate.year;
    }).toList();

    return yearTransactions;
  }

  // * Selected Date Transaction
  @override
  List<TransactionEntity> fetchTransactionsForDay(
      DateTime selectedDate, List<TransactionEntity> totalTransactions) {
    return totalTransactions.where((transaction) {
      return transaction.date.day == selectedDate.day &&
          transaction.date.month == selectedDate.month &&
          transaction.date.year == selectedDate.year;
    }).toList();
  }

  @override
  List<TransactionEntity> getTransactionsForToday() {
    return [];
  }

  @override
  List<TransactionEntity> fetchTransactionsForMonth(
      DateTime selectedDate, List<TransactionEntity> totalTransactions) {
    final startOfMonth = DateTime(selectedDate.year, selectedDate.month)
        .subtract(const Duration(days: 1));
    final endOfMonth = DateTime(selectedDate.year, selectedDate.month + 1);
    List<TransactionEntity> monthTransactions =
        totalTransactions.where((mainTransaction) {
      DateTime transactionDate = mainTransaction.date;
      return transactionDate.isAfter(startOfMonth) &&
          transactionDate.isBefore(endOfMonth);
    }).toList();

    return monthTransactions;
  }

  @override
  List<TransactionEntity> fetchTransactionsForWeek(
      DateTime selectedDate, List<TransactionEntity> totalTransactions) {
    final startOfWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    List<TransactionEntity> weekTransactions =
        totalTransactions.where((mainTransaction) {
      DateTime mainTransactionDate = mainTransaction.date;
      return mainTransactionDate
              .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          mainTransactionDate.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();

    return weekTransactions;
  }

  @override
  List<TransactionEntity> fetchTransactionsForYear(
      DateTime selectedDate, List<TransactionEntity> totalTransactions) {
    List<TransactionEntity> yearTransactions =
        totalTransactions.where((transaction) {
      int transactionYear = transaction.date.year;
      return transactionYear == selectedDate.year;
    }).toList();

    return yearTransactions;
  }
}
