import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coin_saver/constants/colors.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/data/datasources/local_datasource/hive/base_hive_local_data_source.dart';
import 'package:coin_saver/features/data/models/account/account_model.dart';
import 'package:coin_saver/features/data/models/category/category_model.dart';
import 'package:coin_saver/features/data/models/currency/currency_model.dart';
import 'package:coin_saver/features/data/models/transaction/transaction_model.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/entities/reminder/reminder_entity.dart';
import 'package:coin_saver/features/domain/entities/settings/settings_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/usecases/exchange_rates/convert_currency_usecase.dart';
import 'package:coin_saver/features/domain/usecases/exchange_rates/get_exchange_rates_from_api_usecase.dart';
import 'package:coin_saver/features/domain/usecases/exchange_rates/get_exchange_rates_from_assets_usecase.dart';
import 'package:coin_saver/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../models/account_type.dart';
import '../../../models/color.dart';
import '../../../models/exchange_rate/exchange_rate_model.dart';
import '../../../models/exchange_rate/rate_model.dart';
import '../../../models/icon_data.dart';
import '../../../models/ownership_type.dart';
import '../../../models/payment_type.dart';
import '../../../models/reminder/reminder_model.dart';

class HiveLocalDataSource implements BaseHiveLocalDataSource {
  final Uuid uuid = sl<Uuid>();
  final awesomeNotifications = sl<AwesomeNotifications>();

  late final Box<AccountModel> accountsBox;
  late final Box<CurrencyModel> currencyBox;
  late final Box<CategoryModel> categoriesBox;
  late final Box<Color> colorsBox;
  late final Box<ExchangeRateModel> exchangeRatesBox;
  late final Box<ReminderModel> remindersBox;
  late final Box settingsBox;
  late List<ExchangeRateModel> exchangeRates;

  // * Initialization Hive
  @override
  Future<void> initHiveAdaptersBoxes() async {}

  @override
  Future<void> initHive() async {
    Hive.registerAdapter<AccountType>(AccountTypeAdapter());
    Hive.registerAdapter<OwnershipType>(OwnershipTypeAdapter());
    Hive.registerAdapter<PaymentType>(PaymentTypeAdapter());
    Hive.registerAdapter<CategoryModel>(CategoryModelAdapter());
    Hive.registerAdapter<CurrencyModel>(CurrencyModelAdapter());
    Hive.registerAdapter<AccountModel>(AccountModelAdapter());
    Hive.registerAdapter<ExchangeRateModel>(ExchangeRateModelAdapter());
    Hive.registerAdapter<RateModel>(RateModelAdapter());
    Hive.registerAdapter<ReminderModel>(ReminderModelAdapter());

    Hive.registerAdapter<IconData>(IconDataAdapter());
    Hive.registerAdapter<Color>(ColorAdapter());
    Hive.registerAdapter<TransactionModel>(TransactionModelAdapter());

    // Hive boxes
    accountsBox = await Hive.openBox<AccountModel>(BoxConst.accounts);
    currencyBox = await Hive.openBox<CurrencyModel>(BoxConst.currency);
    categoriesBox = await Hive.openBox<CategoryModel>(BoxConst.categories);
    colorsBox = await Hive.openBox<Color>(BoxConst.colors);
    remindersBox = await Hive.openBox<ReminderModel>(BoxConst.reminders);
    settingsBox = await Hive.openBox(BoxConst.settings);
    exchangeRatesBox =
        await Hive.openBox<ExchangeRateModel>(BoxConst.exchangeRates);

    // AwesomeNotifications
    await awesomeNotifications.initialize(
      'resource://drawable/res_pig',
      [
        NotificationChannel(
          channelKey: "scheduled",
          channelName: "Scheduled notifications",
          channelDescription: "Notification channel for Coin Saver Reminders",
          importance: NotificationImportance.High,
        )
      ],
      debug: true,
    );

    // Colors
    if (colorsBox.isEmpty) {
      await colorsBox.addAll(mainColors);
    }

    // Exchange rates

    if (exchangeRatesBox.isEmpty) {
      exchangeRates = await sl<GetExchangeRatesFromAssetsUsecase>().call();
      final Map<String, ExchangeRateModel> exchangeRatesMap = {};
      for (ExchangeRateModel exchangeRate in exchangeRates) {
        exchangeRatesMap[exchangeRate.base] = exchangeRate;
      }
      await exchangeRatesBox.putAll(exchangeRatesMap);
    }
    try {
      exchangeRates = await sl<GetExchangeRatesFromApiUsecase>().call();

      await Future.wait(exchangeRates.map((exchangeRate) async {
        await exchangeRatesBox.put(exchangeRate.base, exchangeRate);
      }));
    } catch (e) {
      // print("Error: $e");
    }
  }

  @override
  bool getFirstLaunch() {
    final isFirstLaunch = Hive.box<CurrencyModel>(BoxConst.currency).isEmpty;
    return isFirstLaunch;
  }

  @override
  Future<void> firstInitUser(CurrencyEntity currencyEntity, String total,
      String main, String reminderTitle, String reminderBody) async {
    await currencyBox.put(
        currencyEntity.code, CurrencyModel.fromEntity(currencyEntity));
    if (colorsBox.isEmpty) {
      await colorsBox.addAll(mainColors);
    }
    await accountsBox.put(
        "total",
        AccountModel(
            id: "total",
            name: total,
            iconData: FontAwesomeIcons.sackDollar,
            type: AccountType.cash,
            color: Colors.blue.shade800,
            balance: 0,
            currency: CurrencyModel.fromEntity(currencyEntity),
            isPrimary: false,
            isActive: true,
            ownershipType: OwnershipType.joint,
            openingDate: DateTime(2000),
            transactionHistory: const []));
    await accountsBox.put(
        "main",
        AccountModel(
            id: "main",
            name: main,
            iconData: FontAwesomeIcons.coins,
            type: AccountType.cash,
            color: Colors.blue.shade800,
            balance: 0,
            currency: CurrencyModel.fromEntity(currencyEntity),
            isPrimary: true,
            isActive: true,
            ownershipType: OwnershipType.individual,
            openingDate: DateTime.now(),
            transactionHistory: const []));
    // Reminder
    ReminderEntity reminder = ReminderEntity(
      id: 1,
      title: reminderTitle,
      body: reminderBody,
      hour: 20,
      minute: 00,
      isActive: true,
      repeats: true,
    );
    var isNotificationAllowed =
        await sl<AwesomeNotifications>().isNotificationAllowed();
    if (isNotificationAllowed) {
      await createReminder(reminderEntity: reminder);
    }
    await sl<GetExchangeRatesFromApiUsecase>().call();
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
    final AccountModel newAccount = AccountModel(
        id: accountEntity.id,
        name: accountEntity.name,
        iconData: accountEntity.iconData,
        type: accountEntity.type,
        color: accountEntity.color,
        balance: accountEntity.balance,
        currency: CurrencyModel.fromEntity(accountEntity.currency),
        isPrimary: accountEntity.isPrimary,
        isActive: true,
        ownershipType: accountEntity.ownershipType,
        openingDate: accountEntity.openingDate,
        transactionHistory: accountEntity.transactionHistory
            .map((e) => TransactionModel.fromEntity(e))
            .toList());

    try {
      await accountsBox.put(accountEntity.id, newAccount);

      final totalAccount = accountsBox.get("total");
      if (totalAccount != null) {
        final exchangeRate = sl<ConvertCurrencyUsecase>()
            .call(accountEntity.currency.code, totalAccount.currency.code);
        final convertedAmount = exchangeRate * accountEntity.balance;
        final updatedTotalAccount = totalAccount.copyWith(
          balance: totalAccount.balance + convertedAmount,
        );
        await accountsBox.put(totalAccount.id, updatedTotalAccount);
      }
      // End updating
    } catch (e) {
      // Handle the error, log, or revert changes if needed
      // ...
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount(String id) async {
    final existingAccount = accountsBox.get(id);
    final accounts = accountsBox.values.cast<AccountModel>().toList();
    if (existingAccount == null) {
      throw Exception("Account not Found!");
    }
    final double oldAccountBalance = existingAccount.balance;
    try {
      await accountsBox.delete(id);
      await Future.wait(accounts.map((account) async {
        final updatedAccount = account.copyWith(
            transactionHistory: List<TransactionModel>.from(
                    account.transactionHistory)
                .where((element) =>
                    element.accountFromId != id && element.accountToId != id)
                .toList());
        if (account.id != id) {
          await accountsBox.put(account.id, updatedAccount);
          // await Future.delayed(const Duration(milliseconds: 300));
        }
      }));
      final totalAccount = accountsBox.get("total");
      if (totalAccount != null) {
        final exchangeRate = sl<ConvertCurrencyUsecase>()
            .call(existingAccount.currency.code, totalAccount.currency.code);
        final convertedAmount = exchangeRate * oldAccountBalance;
        final updatedTotalAccount = totalAccount.copyWith(
          balance: totalAccount.balance - convertedAmount,
        );
        await accountsBox.put(totalAccount.id, updatedTotalAccount);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    List<AccountEntity> accounts = accountsBox.values.toList()
      ..sort(
        (a, b) => a.openingDate.compareTo(b.openingDate),
      );
    return accounts;
  }

  @override
  Future<void> updateAccount(AccountEntity accountEntity) async {
    // Step 1: Validate the account
    final existingAccount = accountsBox.get(accountEntity.id);
    if (existingAccount == null) {
      // Account doesn't exist, handle error or throw an exception
      throw Exception("Account not found!");
    }

    final double oldAccountBalance = existingAccount.balance;
    final double updatedAccountBalance =
        accountEntity.balance - oldAccountBalance;

    // Step 7: Update account and total account (if needed) inside a try-catch block
    try {
      // Start updating
      final updatedAccount = AccountModel(
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
              .toList());
      await accountsBox.put(existingAccount.id, updatedAccount);

      final totalAccount = accountsBox.get("total");
      if (totalAccount != null) {
        final exchangeRate = sl<ConvertCurrencyUsecase>()
            .call(existingAccount.currency.code, totalAccount.currency.code);
        final convertedAmount = exchangeRate * updatedAccountBalance;
        final updatedTotalAccount = totalAccount.copyWith(
          balance: totalAccount.balance + convertedAmount,
        );
        await accountsBox.put(totalAccount.id, updatedTotalAccount);
      }
      // End updating
    } catch (e) {
      // Handle the error, log, or revert changes if needed
      // ...
      rethrow;
    }
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
      await accountsBox.put(existingAccount.id, updatedAccount);

      final totalAccount = accountsBox.get("total");
      if (totalAccount != null) {
        final exchangeRate = sl<ConvertCurrencyUsecase>()
            .call(existingAccount.currency.code, totalAccount.currency.code);
        final convertedAmount = transactionAmount * exchangeRate;
        final updatedTotalAccount = totalAccount.copyWith(
          balance: totalAccount.balance + convertedAmount,
          transactionHistory: List.from(totalAccount.transactionHistory)
            ..add(newTransaction.copyWith(
                amount: transactionEntity.amount * exchangeRate)),
        );
        await accountsBox.put(totalAccount.id, updatedTotalAccount);
      }
      // End updating
    } catch (e) {
      // Handle the error, log, or revert changes if needed
      // ...
      rethrow;
    }
  }

  @override
  Future<void> addTransfer({
    required AccountEntity accountFrom,
    required AccountEntity accountTo,
    required TransactionEntity transactionEntity,
  }) async {
    final AccountModel accountModelFrom = AccountModel(
        id: accountFrom.id,
        name: accountFrom.name,
        iconData: accountFrom.iconData,
        type: accountFrom.type,
        color: accountFrom.color,
        balance: accountFrom.balance - transactionEntity.amountFrom!,
        currency: CurrencyModel.fromEntity(accountFrom.currency),
        isPrimary: accountFrom.isPrimary,
        isActive: accountFrom.isActive,
        ownershipType: accountFrom.ownershipType,
        openingDate: accountFrom.openingDate,
        transactionHistory: List.from(accountFrom.transactionHistory)
            .map((e) => TransactionModel.fromEntity(e))
            .toList()
          ..add(TransactionModel.fromEntity(transactionEntity)));
    final AccountModel accountModelTo = AccountModel(
        id: accountTo.id,
        name: accountTo.name,
        iconData: accountTo.iconData,
        type: accountTo.type,
        color: accountTo.color,
        balance: accountTo.balance + transactionEntity.amountTo!,
        currency: CurrencyModel.fromEntity(accountTo.currency),
        isPrimary: accountTo.isPrimary,
        isActive: accountTo.isActive,
        ownershipType: accountTo.ownershipType,
        openingDate: accountTo.openingDate,
        transactionHistory: List.from(accountTo.transactionHistory)
            .map((e) => TransactionModel.fromEntity(e))
            .toList()
          ..add(TransactionModel.fromEntity(transactionEntity)));
    try {
      final totalAccount = accountsBox.get("total");

      if (totalAccount != null) {
        final updatedTotalAccount = totalAccount.copyWith(
            transactionHistory:
                List<TransactionModel>.from(totalAccount.transactionHistory)
                  ..add(TransactionModel.fromEntity(transactionEntity)));
        await accountsBox.put(accountModelFrom.id, accountModelFrom);
        await accountsBox.put(accountModelTo.id, accountModelTo);
        await accountsBox.put(totalAccount.id, updatedTotalAccount);
      }
    } catch (_) {}
  }

  @override
  Future<void> updateTransfer(
      {required AccountEntity accountFrom,
      required AccountEntity accountTo,
      required AccountEntity oldAccountTo,
      required AccountEntity oldAccountFrom,
      required TransactionEntity transactionEntity}) async {
    try {
      final totalAccount = accountsBox.get("total");
      // Old transfer
      final oldTransfer = totalAccount!.transactionHistory
          .firstWhere((element) => element.id == transactionEntity.id);
      final amountDifferenceFrom = -transactionEntity.amountFrom!;
      final amountDifferenceTo = transactionEntity.amountTo!;
      // Delete from old accounts
      final oldAccountModelFrom = AccountModel(
          id: oldAccountFrom.id,
          name: oldAccountFrom.name,
          iconData: oldAccountFrom.iconData,
          type: oldAccountFrom.type,
          color: oldAccountFrom.color,
          balance: oldAccountFrom.balance + oldTransfer.amountFrom!,
          currency: CurrencyModel.fromEntity(oldAccountFrom.currency),
          isPrimary: oldAccountFrom.isPrimary,
          isActive: oldAccountFrom.isActive,
          ownershipType: oldAccountFrom.ownershipType,
          openingDate: oldAccountFrom.openingDate,
          transactionHistory: List.from(oldAccountFrom.transactionHistory)
              .map((e) => TransactionModel.fromEntity(e))
              .where((element) => element.id != transactionEntity.id)
              .toList());
      final oldAccountModelTo = AccountModel(
          id: oldAccountTo.id,
          name: oldAccountTo.name,
          iconData: oldAccountTo.iconData,
          type: oldAccountTo.type,
          color: oldAccountTo.color,
          balance: oldAccountTo.balance - oldTransfer.amountTo!,
          currency: CurrencyModel.fromEntity(oldAccountTo.currency),
          isPrimary: oldAccountTo.isPrimary,
          isActive: oldAccountTo.isActive,
          ownershipType: oldAccountTo.ownershipType,
          openingDate: oldAccountTo.openingDate,
          transactionHistory: List.from(oldAccountTo.transactionHistory)
              .map((e) => TransactionModel.fromEntity(e))
              .where((element) => element.id != transactionEntity.id)
              .toList());
      // Putting old accounts
      await accountsBox.put(oldAccountModelTo.id, oldAccountModelTo);
      await accountsBox.put(oldAccountModelFrom.id, oldAccountModelFrom);
      // Getting updated accounts
      final newAccountFrom = accountsBox.get(accountFrom.id);
      final newAccountTo = accountsBox.get(accountTo.id);
      final AccountModel accountModelFrom = AccountModel(
          id: newAccountFrom!.id,
          name: newAccountFrom.name,
          iconData: newAccountFrom.iconData,
          type: newAccountFrom.type,
          color: newAccountFrom.color,
          balance: newAccountFrom.balance + amountDifferenceFrom,
          currency: newAccountFrom.currency,
          isPrimary: newAccountFrom.isPrimary,
          isActive: newAccountFrom.isActive,
          ownershipType: newAccountFrom.ownershipType,
          openingDate: newAccountFrom.openingDate,
          transactionHistory: List.from(newAccountFrom.transactionHistory)
              .map((e) => TransactionModel.fromEntity(e))
              .where((element) => element.id != transactionEntity.id)
              .toList()
            ..add(TransactionModel.fromEntity(transactionEntity)));
      final AccountModel accountModelTo = AccountModel(
          id: newAccountTo!.id,
          name: newAccountTo.name,
          iconData: newAccountTo.iconData,
          type: newAccountTo.type,
          color: newAccountTo.color,
          balance: newAccountTo.balance + amountDifferenceTo,
          currency: newAccountTo.currency,
          isPrimary: newAccountTo.isPrimary,
          isActive: newAccountTo.isActive,
          ownershipType: newAccountTo.ownershipType,
          openingDate: newAccountTo.openingDate,
          transactionHistory: List.from(newAccountTo.transactionHistory)
              .map((e) => TransactionModel.fromEntity(e))
              .where((element) => element.id != transactionEntity.id)
              .toList()
            ..add(TransactionModel.fromEntity(transactionEntity)));

      final updatedTotalAccount = totalAccount.copyWith(
          transactionHistory:
              List<TransactionModel>.from(totalAccount.transactionHistory)
                  .where((element) => element.id != transactionEntity.id)
                  .toList()
                ..add(TransactionModel.fromEntity(transactionEntity)));
      List accounts = [
        accountsBox.put(totalAccount.id, updatedTotalAccount),
        accountsBox.put(accountModelFrom.id, accountModelFrom),
        accountsBox.put(accountModelTo.id, accountModelTo),
      ];
      await Future.wait(accounts.map((account) async {
        await account;
      }));
    } catch (_) {}
  }

  @override
  Future<void> deleteTransfer(
      {required AccountEntity accountFrom,
      required AccountEntity accountTo,
      required TransactionEntity transactionEntity}) async {
    final AccountModel accountModelFrom = AccountModel(
        id: accountFrom.id,
        name: accountFrom.name,
        iconData: accountFrom.iconData,
        type: accountFrom.type,
        color: accountFrom.color,
        balance: accountFrom.balance + transactionEntity.amountFrom!,
        currency: CurrencyModel.fromEntity(accountFrom.currency),
        isPrimary: accountFrom.isPrimary,
        isActive: accountFrom.isActive,
        ownershipType: accountFrom.ownershipType,
        openingDate: accountFrom.openingDate,
        transactionHistory: List.from(accountFrom.transactionHistory)
            .where((element) => element.id != transactionEntity.id)
            .map((e) => TransactionModel.fromEntity(e))
            .toList());
    final AccountModel accountModelTo = AccountModel(
        id: accountTo.id,
        name: accountTo.name,
        iconData: accountTo.iconData,
        type: accountTo.type,
        color: accountTo.color,
        balance: accountTo.balance - transactionEntity.amountTo!,
        currency: CurrencyModel.fromEntity(accountTo.currency),
        isPrimary: accountTo.isPrimary,
        isActive: accountTo.isActive,
        ownershipType: accountTo.ownershipType,
        openingDate: accountTo.openingDate,
        transactionHistory: List.from(accountTo.transactionHistory)
            .where((element) => element.id != transactionEntity.id)
            .map((e) => TransactionModel.fromEntity(e))
            .toList());
    try {
      final totalAccount = accountsBox.get("total");

      if (totalAccount != null) {
        final updatedTotalAccount = totalAccount.copyWith(
            transactionHistory:
                List<TransactionModel>.from(totalAccount.transactionHistory)
                    .where((element) => element.id != transactionEntity.id)
                    .toList());
        await accountsBox.put(accountModelFrom.id, accountModelFrom);
        await accountsBox.put(accountModelTo.id, accountModelTo);
        await accountsBox.put(totalAccount.id, updatedTotalAccount);
      }
    } catch (_) {}
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
      await accountsBox.put(existingAccount.id, updatedAccount);

      final totalAccount = accountsBox.get("total");
      if (totalAccount != null) {
        final totalAmount = totalAccount.transactionHistory
            .firstWhere((element) => element.id == transactionEntity.id)
            .amount;
        final convertedAmount =
            transactionEntity.isIncome ? -totalAmount : totalAmount;
        final updatedTotalAccount = totalAccount.copyWith(
          balance: totalAccount.balance + convertedAmount,
          transactionHistory: List<TransactionModel>.from(
            totalAccount.transactionHistory.where(
              (transaction) => transaction.id != transactionEntity.id,
            ),
          ),
        );

        await accountsBox.put(totalAccount.id, updatedTotalAccount);
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
    ); // Step 7: Update account and total account (if needed) inside a try-catch block
    try {
      // Start updating
      final updatedAccount = existingAccount.copyWith(
        balance: updatedAccountBalance,
        transactionHistory: updatedTransactionHistory,
      );
      await accountsBox.put(existingAccount.id, updatedAccount);

      final totalAccount = accountsBox.get("total");
      if (totalAccount != null) {
        final exchangeRate = sl<ConvertCurrencyUsecase>()
            .call(existingAccount.currency.code, totalAccount.currency.code);

        final convertedAmount = amountDifference * exchangeRate;
        final updatedTotalAccount = totalAccount.copyWith(
          balance: totalAccount.balance + convertedAmount,
          transactionHistory: List<TransactionModel>.from(
            totalAccount.transactionHistory
                .where((element) => element.id != transactionEntity.id)
                .toList()
              ..add(updatedTransaction.copyWith(
                  amount: transactionEntity.amount * exchangeRate)),
          ),
        );
        await accountsBox.put(totalAccount.id, updatedTotalAccount);
      }
      // End updating
    } catch (e) {
      // Handle the error, log, or revert changes if needed
      // ...
      rethrow;
    }
  }

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
      code: key,
      name: currencyEntity.name,
      symbol: currencyEntity.symbol,
    );

    await currencyBox.put(key, currencyModel);
    await sl<GetExchangeRatesFromApiUsecase>().call();
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
  Future<void> deleteCategory(
    bool isIncome,
    String categoryId,
  ) async {
    final accounts = accountsBox.values.cast<AccountModel>().toList();
    final categories = categoriesBox.values.cast<CategoryModel>().toList();
    final categoryIncomeOther =
        categories.firstWhere((element) => element.id == "otherIncome");
    final categoryExpenseOther =
        categories.firstWhere((element) => element.id == "otherExpense");
    CategoryModel categoryModel =
        isIncome ? categoryIncomeOther : categoryExpenseOther;
    await Future.wait(accounts.map((account) async {
      final List<TransactionModel> updatedTransactions = [];
      // Updating transaction list
      for (var transaction in account.transactionHistory) {
        if (transaction.category.id == categoryId) {
          updatedTransactions.add(transaction.copyWith(
              category: categoryModel,
              iconData: categoryModel.iconData,
              color: categoryModel.color));
        } else {
          updatedTransactions.add(transaction);
        }
      }

      await accountsBox.put(
          account.id,
          account.copyWith(
            transactionHistory: updatedTransactions,
          ));
    }));

    await categoriesBox.delete(categoryId);
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    List<CategoryEntity> categories =
        categoriesBox.values.map((category) => category.toEntity()).toList();
    return categories;
  }

  @override
  Future<void> updateCategory(CategoryEntity categoryEntity) async {
    final accounts = accountsBox.values.cast<AccountModel>().toList();
    CategoryModel categoryModel = CategoryModel.fromEntity(categoryEntity);
    await Future.wait(accounts.map((account) async {
      final List<TransactionModel> updatedTransactions = [];
      // Updating transaction list
      for (var transaction in account.transactionHistory) {
        if (transaction.category.id == categoryEntity.id &&
            transaction.category.isIncome == categoryEntity.isIncome) {
          updatedTransactions
              .add(transaction.copyWith(category: categoryModel));
        } else {
          updatedTransactions.add(transaction);
        }
      }

      await accountsBox.put(
          account.id,
          account.copyWith(
            transactionHistory: updatedTransactions,
          ));
    }));

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

  // Reminders
  @override
  Future<void> createReminder({required ReminderEntity reminderEntity}) async {
    await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: reminderEntity.id,
        channelKey: 'scheduled',
        title: reminderEntity.title,
        body: reminderEntity.body,
        largeIcon: 'resource://drawable/res_pig_logo',
      ),
      schedule: NotificationCalendar(
        day: reminderEntity.day,
        month: reminderEntity.month,
        year: reminderEntity.year,
        hour: reminderEntity.hour,
        minute: reminderEntity.minute,
        weekday: reminderEntity.weekday,
        second: 0,
        timeZone: await awesomeNotifications.getLocalTimeZoneIdentifier(),
      ),
    );
    await remindersBox.put(
        reminderEntity.id, ReminderModel.fromEntity(reminderEntity));
  }

  @override
  Future<void> deleteReminder({required ReminderEntity reminderEntity}) async {
    await awesomeNotifications.cancel(reminderEntity.id);
    await remindersBox.delete(
      reminderEntity.id,
    );
  }

  @override
  List<ReminderEntity> getReminders() {
    final List<ReminderEntity> reminders =
        remindersBox.values.cast<ReminderModel>().toList();
    return reminders;
  }

  @override
  Future<void> updateReminder({required ReminderEntity reminderEntity}) async {
    if (reminderEntity.isActive) {
      await awesomeNotifications.createNotification(
        content: NotificationContent(
            id: reminderEntity.id,
            channelKey: 'scheduled',
            title: reminderEntity.title,
            body: reminderEntity.body,
            largeIcon: 'resource://drawable/res_pig_logo'),
        schedule: NotificationCalendar(
          day: reminderEntity.day,
          month: reminderEntity.month,
          year: reminderEntity.year,
          hour: reminderEntity.hour,
          minute: reminderEntity.minute,
          weekday: reminderEntity.weekday,
          second: 0,
          timeZone: await awesomeNotifications.getLocalTimeZoneIdentifier(),
        ),
      );
    } else {
      await awesomeNotifications.cancel(reminderEntity.id);
    }
    await remindersBox.put(
        reminderEntity.id, ReminderModel.fromEntity(reminderEntity));
  }

  // * Settings
  @override
  Future<void> deleteAllData() async {
    final boxes = [
      Hive.box<AccountModel>(BoxConst.accounts),
      Hive.box<CategoryModel>(BoxConst.categories),
      Hive.box<Color>(BoxConst.colors),
      Hive.box<CurrencyModel>(BoxConst.currency),
    ];
    await Future.wait(boxes.map((e) => e.clear()));
  }

  @override
  Future<void> updateLanguage(String language) async {
    await settingsBox.put(SettingsConst.language, language);
    await settingsBox.put(SettingsConst.languageChanged, true);
  }

  @override
  Future<void> updateTheme(bool isDarkTheme) async {
    await settingsBox.put(SettingsConst.isDarkTheme, isDarkTheme);
  }

  @override
  Future<SettingsEntity> getSettings() async {
    final language = await settingsBox.get(SettingsConst.language);
    final isDarkTheme = await settingsBox.get(SettingsConst.isDarkTheme);
    return SettingsEntity(
      language: language,
      isDarkTheme: isDarkTheme ?? false,
    );
  }
}
