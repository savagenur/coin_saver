import 'package:coin_saver/features/data/datasources/local_datasource/base_hive_local_data_source.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

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
  Future<void> initHive() async => hiveLocalDataSource.initHive();

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
  Future<void> deleteCategory(String categoryId) async =>
      hiveLocalDataSource.deleteCategory(categoryId);

  @override
  Future<List<CategoryEntity>> getCategories() async =>
      hiveLocalDataSource.getCategories();

  @override
  Future<void> updateCategory(int index, CategoryEntity categoryEntity) async =>
      hiveLocalDataSource.updateCategory(index, categoryEntity);

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
}
