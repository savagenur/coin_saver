import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'package:coin_saver/constants/colors.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/constants/currencies.dart';
import 'package:coin_saver/constants/main_categories.dart';
import 'package:coin_saver/features/data/datasources/local_datasource/base_hive_local_data_source.dart';
import 'package:coin_saver/features/data/models/account/account_model.dart';
import 'package:coin_saver/features/data/models/category/category_model.dart';
import 'package:coin_saver/features/data/models/currency/currency_model.dart';
import 'package:coin_saver/features/data/models/transaction/transaction_model.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/injection_container.dart';

import '../../models/account_type.dart';
import '../../models/color.dart';
import '../../models/icon_data.dart';
import '../../models/ownership_type.dart';
import '../../models/payment_type.dart';

class HiveLocalDataSource implements BaseHiveLocalDataSource {
  final Uuid uuid = sl<Uuid>();
  late final Box<AccountModel> accountsBox;
  late final Box<CurrencyModel> currencyBox;
  late final Box<CategoryModel> categoriesBox;
  late final Box<Color> colorsBox;

  // * Initialization Hive
  @override
  Future<void> initHiveAdaptersBoxes() async {
    Hive.registerAdapter<AccountType>(AccountTypeAdapter());
    Hive.registerAdapter<OwnershipType>(OwnershipTypeAdapter());
    Hive.registerAdapter<PaymentType>(PaymentTypeAdapter());
    Hive.registerAdapter<CategoryModel>(CategoryModelAdapter());
    Hive.registerAdapter<CurrencyModel>(CurrencyModelAdapter());
    Hive.registerAdapter<AccountModel>(AccountModelAdapter());

    Hive.registerAdapter<IconData>(IconDataAdapter());
    Hive.registerAdapter<Color>(ColorAdapter());
    Hive.registerAdapter<TransactionModel>(TransactionModelAdapter());

    accountsBox = await Hive.openBox<AccountModel>(BoxConst.accounts);
    currencyBox = await Hive.openBox<CurrencyModel>(BoxConst.currency);
    categoriesBox = await Hive.openBox<CategoryModel>(BoxConst.categories);
    colorsBox = await Hive.openBox<Color>(BoxConst.colors);
  }

  @override
  Future<void> initHive() async {
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
              currency: currencyBox.get("KGS")!,
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
              currency: currencyBox.get("KGS")!,
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
              currency: currencyBox.get("KGS")!,
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
    await accountsBox.clear();
  }

  @override
  Future<void> setPrimaryAccount(String accountId) async {
    final accounts = accountsBox.values.toList();
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
    await accountsBox.put(
      accountEntity.id,
      AccountModel(
          id: accountEntity.id,
          name: accountEntity.name,
          iconData: accountEntity.iconData,
          type: accountEntity.type,
          color: accountEntity.color,
          balance: accountEntity.balance,
          currency: accountEntity.currency,
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
    await accountsBox.delete(id);
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    List<AccountEntity> accounts = accountsBox.values.toList();
    return accounts;
  }

  @override
  Future<void> updateAccount(AccountEntity accountEntity) async {
    await accountsBox.put(
        accountEntity.id,
        AccountModel(
            id: accountEntity.id,
            name: accountEntity.name,
            iconData: accountEntity.iconData,
            type: accountEntity.type,
            color: accountEntity.color,
            balance: accountEntity.balance,
            currency: accountEntity.currency,
            isPrimary: accountEntity.isPrimary,
            isActive: accountEntity.isActive,
            ownershipType: accountEntity.ownershipType,
            openingDate: accountEntity.openingDate,
            transactionHistory: accountEntity.transactionHistory
                .map((e) => TransactionModel.fromEntity(e))
                .toList()));
  }

  // * Transaction
  @override
  Future<void> addTransaction({
    required AccountEntity accountEntity,
    required TransactionEntity transactionEntity,
  }) async {
    // Step 1: Validate the account
    final existingAccount = accountsBox.get(accountEntity.id);
    if (existingAccount == null) {
      // Account doesn't exist, handle error or throw an exception
      throw Exception("Account not found!");
    }

    // Step 2: Calculate the updated account balance
    final double transactionAmount = transactionEntity.isIncome
        ? transactionEntity.amount
        : -transactionEntity.amount;

    final double updatedAccountBalance =
        existingAccount.balance + transactionAmount;

    // Step 3: Create the new transaction
    final TransactionModel newTransaction = TransactionModel(
      id: transactionEntity.id,
      date: transactionEntity.date,
      amount: transactionEntity.amount,
      category: CategoryModel.fromEntity(transactionEntity.category),
      iconData: transactionEntity.iconData,
      accountId: accountEntity.id,
      isIncome: transactionEntity.isIncome,
      color: transactionEntity.color,
      description: transactionEntity.description,
    );

    // Step 4: Update account and total account (if needed) inside a try-catch block
    try {
      // Start updating
      final updatedAccount = existingAccount.copyWith(
        balance: updatedAccountBalance,
        transactionHistory: List.from(existingAccount.transactionHistory)
          ..add(newTransaction),
      );
      accountsBox.put(existingAccount.id, updatedAccount);

      final totalAccount = accountsBox.get("total");
      if (totalAccount != null) {
        final updatedTotalAccount = totalAccount.copyWith(
          balance: totalAccount.balance + transactionAmount,
          transactionHistory: List.from(totalAccount.transactionHistory)
            ..add(newTransaction),
        );
        accountsBox.put(totalAccount.id, updatedTotalAccount);
      }
      // End updating
    } catch (e) {
      // Handle the error, log, or revert changes if needed
      // ...
      rethrow;
    }
  }

  @override
  Future<void> deleteTransaction({
    required TransactionEntity transactionEntity,
    required AccountEntity accountEntity,
  }) async {
    // Step 1: Validate the account
    final existingAccount = accountsBox.get(accountEntity.id);
    if (existingAccount == null) {
      // Account doesn't exist, handle error or throw an exception
      throw Exception("Account not found!");
    }

    // Step 2: Calculate the updated account balance
    final double transactionAmount = transactionEntity.isIncome
        ? -transactionEntity.amount
        : transactionEntity.amount;

    final double updatedAccountBalance =
        existingAccount.balance + transactionAmount;

    // Step 3: Create a new transaction history list without the deleted transaction
    final updatedTransactionHistory = List<TransactionModel>.from(
      existingAccount.transactionHistory.where(
        (transaction) => transaction.id != transactionEntity.id,
      ),
    );
    // print(
        // "updatedTransactionHistory.contains transactionId: ${updatedTransactionHistory.contains(transactionEntity)}");

    // Step 4: Update account and total account (if needed) inside a try-catch block
    try {
      // Start updating
      final updatedAccount = existingAccount.copyWith(
        balance: updatedAccountBalance,
        transactionHistory: updatedTransactionHistory,
      );
      accountsBox.put(existingAccount.id, updatedAccount);

      final totalAccount = accountsBox.get("total");
      if (totalAccount != null) {
        final updatedTotalAccount = totalAccount.copyWith(
          balance: totalAccount.balance + transactionAmount,
          transactionHistory: List<TransactionModel>.from(
            totalAccount.transactionHistory.where(
              (transaction) => transaction.id != transactionEntity.id,
            ),
          ),
        );
        accountsBox.put(totalAccount.id, updatedTotalAccount);
      }
      // End updating
    } catch (e) {
      // Handle the error, log, or revert changes if needed
      // ...
      rethrow;
    }
  }

  @override
  Future<void> updateTransaction({
    required TransactionEntity transactionEntity,
    required AccountEntity accountEntity,
  }) async {
    // Step 1: Validate the account
    final existingAccount = accountsBox.get(accountEntity.id);
    if (existingAccount == null) {
      // Account doesn't exist, handle error or throw an exception
      throw Exception("Account not found!");
    }

    // Step 2: Find the old transaction to get its amount
    final TransactionEntity oldTransaction = accountEntity.transactionHistory
        .firstWhere((element) => element.id == transactionEntity.id);

    // Step 3: Calculate the difference in amounts to update the account balance
    final double amountDifference = transactionEntity.isIncome
        ? transactionEntity.amount - oldTransaction.amount
        : oldTransaction.amount - transactionEntity.amount;

    // Step 4: Calculate the updated account balance
    final double updatedAccountBalance =
        existingAccount.balance + amountDifference;

    // Step 5: Create a new transaction with the updated values
    final TransactionModel updatedTransaction = TransactionModel(
      id: transactionEntity.id,
      date: transactionEntity.date,
      amount: transactionEntity.amount,
      category: CategoryModel.fromEntity(transactionEntity.category),
      iconData: transactionEntity.iconData,
      accountId: accountEntity.id,
      isIncome: transactionEntity.isIncome,
      color: transactionEntity.color,
      description: transactionEntity.description,
    );

    // Step 6: Create a new transaction history list with the updated transaction
    final updatedTransactionHistory = List<TransactionModel>.from(
      accountEntity.transactionHistory
          .where((element) => element.id != transactionEntity.id)
          .toList()
        ..add(updatedTransaction),
    );

    // Step 7: Update account and total account (if needed) inside a try-catch block
    try {
      // Start updating
      final updatedAccount = existingAccount.copyWith(
        balance: updatedAccountBalance,
        transactionHistory: updatedTransactionHistory,
      );
      accountsBox.put(existingAccount.id, updatedAccount);

      final totalAccount = accountsBox.get("total");
      if (totalAccount != null) {
        final updatedTotalAccount = totalAccount.copyWith(
          balance: totalAccount.balance + amountDifference,
          transactionHistory: List<TransactionModel>.from(
            totalAccount.transactionHistory
                .where((element) => element.id != transactionEntity.id)
                .toList()
              ..add(updatedTransaction),
          ),
        );
        accountsBox.put(totalAccount.id, updatedTotalAccount);
      }
      // End updating
    } catch (e) {
      // Handle the error, log, or revert changes if needed
      // ...
      rethrow;
    }
  }

  // Todo
  @override
  List<TransactionEntity> getTransactions() {
    final primaryAccount =
        accountsBox.values.firstWhere((element) => element.isPrimary);
    final List<TransactionEntity> transactions = primaryAccount
        .transactionHistory
        .map((transaction) => transaction.toEntity())
        .toList();
    return transactions;
  }

  // * Currency
  @override
  Future<void> createCurrency(CurrencyEntity currencyEntity) async {
    final key = currencyEntity.code;
    final CurrencyModel currencyModel = CurrencyModel(
      code: currencyEntity.code,
      name: currencyEntity.name,
      symbol: currencyEntity.symbol,
    );

    await currencyBox.put(key, currencyModel);
  }

  @override
  Future<CurrencyEntity> getCurrency() async {
    return currencyBox.getAt(0)!.toEntity();
  }

  @override
  Future<void> updateCurrency(CurrencyEntity currencyEntity) async {
    final CurrencyModel currencyModel = CurrencyModel(
      code: currencyEntity.code,
      name: currencyEntity.name,
      symbol: currencyEntity.symbol,
    );
    await currencyBox.putAt(0, currencyModel);
  }

  // * Category
  @override
  Future<void> createCategory(CategoryEntity categoryEntity) async {
    CategoryModel categoryModel = CategoryModel(
      id: categoryEntity.id,
      name: categoryEntity.name,
      iconData: categoryEntity.iconData,
      color: categoryEntity.color,
      isIncome: categoryEntity.isIncome,
      dateTime: categoryEntity.dateTime,
    );
    await categoriesBox.put(categoryEntity.id, categoryModel);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await categoriesBox.delete(categoryId);
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    List<CategoryEntity> categories =
        categoriesBox.values.map((category) => category.toEntity()).toList();
    return categories;
  }

  @override
  Future<void> updateCategory(int index, CategoryEntity categoryEntity) async {
    CategoryModel categoryModel = CategoryModel(
      id: categoryEntity.id,
      name: categoryEntity.name,
      iconData: categoryEntity.iconData,
      color: categoryEntity.color,
      isIncome: categoryEntity.isIncome,
      dateTime: categoryEntity.dateTime,
    );

    await categoriesBox.put(
      categoryEntity.id,
      categoryModel,
    );
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
    final selectedDate = DateTime.now();

    // Step 1: Get the primary account (or null if not found)
    final primaryAccount = accountsBox.values
        .firstWhere((account) => account.isPrimary, orElse: () => accountError);

    // Step 2: Check if the primary account exists
    if (primaryAccount.id == "null") {
      // Primary account not found, handle error or return an empty list
      return [];
    }

    // Step 3: Get the transaction history of the primary account
    final totalTransactions = primaryAccount.transactionHistory;

    // Step 4: Filter transactions for today
    final transactionsForToday = totalTransactions.where((transaction) {
      return transaction.date.day == selectedDate.day &&
          transaction.date.month == selectedDate.month &&
          transaction.date.year == selectedDate.year;
    }).toList();

    return transactionsForToday;
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
          mainTransactionDate.isBefore(endOfWeek.add(const Duration(days: 0)));
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

  @override
  List<TransactionEntity> fetchTransactionsForPeriod(DateTime selectedStart,
      DateTime selectedEnd, List<TransactionEntity> transactions) {
    List<TransactionEntity> periodTransactions =
        transactions.where((transaction) {
      DateTime transactionDate = transaction.date;
      return transactionDate
              .isAfter(selectedStart.subtract(const Duration(days: 1))) &&
          transactionDate.isBefore(selectedEnd.add(const Duration(days: 1)));
    }).toList();
    return periodTransactions;
  }
}
