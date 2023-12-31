import 'package:coin_saver/features/data/datasources/local_datasource/hive/base_hive_local_data_source.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/entities/reminder/reminder_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

import '../../domain/entities/settings/settings_entity.dart';
import '../../domain/entities/transaction/transaction_entity.dart';

class HiveRepository implements BaseHiveRepository {
  final BaseHiveLocalDataSource hiveLocalDataSource;
  HiveRepository({
    required this.hiveLocalDataSource,
  });

  // Initialization Hive
  @override
  Future<void> initHiveAdaptersBoxes() async =>
      hiveLocalDataSource.initHiveAdaptersBoxes();
  @override
  bool getFirstLaunch()  => hiveLocalDataSource.getFirstLaunch();
  @override
  Future<void> initHive() async => hiveLocalDataSource.initHive();
  @override
  Future<void> firstInitUser(CurrencyEntity currencyEntity, String total,
      String main, String reminderTitle, String reminderBody) async =>
      hiveLocalDataSource.firstInitUser(currencyEntity, total, main, reminderTitle, reminderBody);
  // Account
  @override
  Future<void> createAccount(AccountEntity accountEntity) async =>
      hiveLocalDataSource.createAccount(accountEntity);
  @override
  Future<void> setPrimaryAccount(String accountId) async =>
      hiveLocalDataSource.setPrimaryAccount(accountId);

  @override
  Future<void> deleteAccount(String id) async =>
      hiveLocalDataSource.deleteAccount(id);

  @override
  Future<List<AccountEntity>> getAccounts() async =>
      hiveLocalDataSource.getAccounts();
  @override
  Future<void> updateAccount(AccountEntity accountEntity) async =>
      hiveLocalDataSource.updateAccount(accountEntity);

  @override
  Future<void> putAccounts(List<AccountEntity> accounts) async =>
      hiveLocalDataSource.putAccounts(accounts);

  // Transaction
  @override
  Future<void> addTransaction({
    required AccountEntity accountEntity,
    required TransactionEntity transactionEntity,
  }) async =>
      hiveLocalDataSource.addTransaction(
        accountEntity: accountEntity,
        transactionEntity: transactionEntity,
      );
  @override
  Future<void> addTransfer({
    required AccountEntity accountFrom,
    required AccountEntity accountTo,
    required TransactionEntity transactionEntity,
  }) async =>
      hiveLocalDataSource.addTransfer(
          accountFrom: accountFrom,
          accountTo: accountTo,
          transactionEntity: transactionEntity);
  @override
  Future<void> deleteTransfer(
          {required AccountEntity accountFrom,
          required AccountEntity accountTo,
          required TransactionEntity transactionEntity}) async =>
      hiveLocalDataSource.deleteTransfer(
          accountFrom: accountFrom,
          accountTo: accountTo,
          transactionEntity: transactionEntity);

  @override
  Future<void> updateTransfer(
          {required AccountEntity accountFrom,
          required AccountEntity accountTo,
          required AccountEntity oldAccountTo,
          required AccountEntity oldAccountFrom,
          required TransactionEntity transactionEntity}) async =>
      hiveLocalDataSource.updateTransfer(
          accountFrom: accountFrom,
          accountTo: accountTo,
          oldAccountTo: oldAccountTo,
          oldAccountFrom: oldAccountFrom,
          transactionEntity: transactionEntity);

  @override
  Future<void> deleteTransaction(
          {required TransactionEntity transactionEntity,
          required AccountEntity accountEntity}) async =>
      hiveLocalDataSource.deleteTransaction(
          transactionEntity: transactionEntity, accountEntity: accountEntity);

  @override
  Future<void> updateTransaction(
          {required TransactionEntity transactionEntity,
          required AccountEntity accountEntity}) async =>
      hiveLocalDataSource.updateTransaction(
          transactionEntity: transactionEntity, accountEntity: accountEntity);

  @override
  List<TransactionEntity> getTransactions() =>
      hiveLocalDataSource.getTransactions();

  // Currency
  @override
  Future<CurrencyEntity> getCurrency() async =>
      hiveLocalDataSource.getCurrency();
  @override
  Future<void> updateCurrency(CurrencyEntity currencyEntity) async =>
      hiveLocalDataSource.updateCurrency(currencyEntity);
  @override
  Future<void> createCurrency(CurrencyEntity currencyEntity) async =>
      hiveLocalDataSource.createCurrency(currencyEntity);

  // Category
  @override
  Future<void> createCategory(CategoryEntity categoryEntity) async =>
      hiveLocalDataSource.createCategory(categoryEntity);

  @override
  Future<void> deleteCategory(bool isIncome, String categoryId) async =>
      hiveLocalDataSource.deleteCategory(isIncome, categoryId);

  @override
  Future<List<CategoryEntity>> getCategories() async =>
      hiveLocalDataSource.getCategories();

  @override
  Future<void> updateCategory(CategoryEntity categoryEntity) async =>
      hiveLocalDataSource.updateCategory(categoryEntity);

  // Selected Date Transactions
  @override
  List<TransactionEntity> getTransactionsForToday() =>
      hiveLocalDataSource.getTransactionsForToday();
  @override
  List<TransactionEntity> fetchTransactionsForDay(
          DateTime selectedDate, List<TransactionEntity> totalTransactions) =>
      hiveLocalDataSource.fetchTransactionsForDay(
          selectedDate, totalTransactions);

  @override
  List<TransactionEntity> fetchTransactionsForMonth(
          DateTime selectedDate, List<TransactionEntity> totalTransactions) =>
      hiveLocalDataSource.fetchTransactionsForMonth(
          selectedDate, totalTransactions);
  @override
  List<TransactionEntity> fetchTransactionsForWeek(
          DateTime selectedDate, List<TransactionEntity> totalTransactions) =>
      hiveLocalDataSource.fetchTransactionsForWeek(
          selectedDate, totalTransactions);

  @override
  List<TransactionEntity> fetchTransactionsForYear(
          DateTime selectedDate, List<TransactionEntity> totalTransactions) =>
      hiveLocalDataSource.fetchTransactionsForYear(
          selectedDate, totalTransactions);
  @override
  List<TransactionEntity> fetchTransactionsForPeriod(DateTime selectedStart,
          DateTime selectedEnd, List<TransactionEntity> totalTransactions) =>
      hiveLocalDataSource.fetchTransactionsForPeriod(
          selectedStart, selectedEnd, totalTransactions);

  // Reminders
  @override
  Future<void> createReminder({required ReminderEntity reminderEntity}) async =>
      hiveLocalDataSource.createReminder(reminderEntity: reminderEntity);

  @override
  Future<void> deleteReminder({required ReminderEntity reminderEntity}) async =>
      hiveLocalDataSource.deleteReminder(reminderEntity: reminderEntity);
  @override
  List<ReminderEntity> getReminders() => hiveLocalDataSource.getReminders();

  @override
  Future<void> updateReminder({required ReminderEntity reminderEntity}) async =>
      hiveLocalDataSource.updateReminder(reminderEntity: reminderEntity);

  // Settings
  @override
  Future<void> updateLanguage(String language) async =>
      hiveLocalDataSource.updateLanguage(language);
  @override
  Future<void> updateTheme(bool isDarkTheme) async =>
      hiveLocalDataSource.updateTheme(isDarkTheme);
  @override
  Future<SettingsEntity> getSettings() async =>
      hiveLocalDataSource.getSettings();

  // Delete all data
  @override
  Future<void> deleteAllData() async => hiveLocalDataSource.deleteAllData();
}
