import 'package:coin_saver/features/data/datasources/local_datasource/base_hive_local_data_source.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

import '../../domain/entities/transaction/transaction_entity.dart';

class HiveRepository implements BaseHiveRepository {
  final BaseHiveLocalDataSource hiveLocalDataSource;
  HiveRepository({
    required this.hiveLocalDataSource,
  });

  // Initialization Hive
  @override
  Future<void> initHive() async => hiveLocalDataSource.initHive();


  // Account
  @override
  Future<void> createAccount(AccountEntity accountEntity) async =>
      hiveLocalDataSource.createAccount(accountEntity);

  @override
  Future<void> deleteAccount(String id) async =>
      hiveLocalDataSource.deleteAccount(id);

  @override
  Future<List<AccountEntity>> getAccounts() async =>
      hiveLocalDataSource.getAccounts();

  // MainTransaction
  @override
  Future<void> createMainTransaction(
          MainTransactionEntity mainTransactionEntity) async =>
      hiveLocalDataSource.createMainTransaction(mainTransactionEntity);

  @override
  Future<void> deleteMainTransaction(String id) async =>
      hiveLocalDataSource.deleteMainTransaction(id);
  @override
  Future<List<MainTransactionEntity>> getMainTransactions() async =>
      hiveLocalDataSource.getMainTransactions();
  @override
  Future<void> updateMainTransaction(
          String oldKey, MainTransactionEntity mainTransactionEntity) async =>
      hiveLocalDataSource.updateMainTransaction(oldKey, mainTransactionEntity);

  @override
  Future<void> updateAccount(AccountEntity accountEntity) async =>
      hiveLocalDataSource.updateAccount(accountEntity);

  @override
  Future<void> selectAccount(
          AccountEntity accountEntity, List<AccountEntity> accounts) async =>
      hiveLocalDataSource.selectAccount(accountEntity, accounts);

  @override
  Future<void> putAccounts(List<AccountEntity> accounts) async =>
      hiveLocalDataSource.putAccounts(accounts);

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
  Future<void> deleteCategory(int index) async =>
      hiveLocalDataSource.deleteCategory(index);

  @override
  Future<List<CategoryEntity>> getCategories() async =>
      hiveLocalDataSource.getCategories();

  @override
  Future<void> updateCategory(int index, CategoryEntity categoryEntity) async =>
      hiveLocalDataSource.updateCategory(index, categoryEntity);

  // Selected Date Transactions
     @override
  List<TransactionEntity> getTransactionsForToday()  =>
      hiveLocalDataSource.getTransactionsForToday();
  @override
  List<TransactionEntity> fetchTransactionsForDay(DateTime selectedDate,List<TransactionEntity> totalTransactions)  =>
      hiveLocalDataSource.fetchTransactionsForDay(selectedDate,totalTransactions);

  @override
  List<TransactionEntity> fetchTransactionsForMonth(DateTime selectedDate,List<TransactionEntity> totalTransactions)  =>
      hiveLocalDataSource.fetchTransactionsForMonth(selectedDate,totalTransactions);
  @override
  List<TransactionEntity> fetchTransactionsForWeek(
          DateTime selectedDate,List<TransactionEntity> totalTransactions)  =>
      hiveLocalDataSource.fetchTransactionsForWeek(selectedDate,totalTransactions);

  @override
  List<TransactionEntity> fetchTransactionsForYear(DateTime selectedDate,List<TransactionEntity> totalTransactions)  =>
      hiveLocalDataSource.fetchTransactionsForYear(selectedDate,totalTransactions);
      
  // Selected Date MainTransactions
   @override
  List<MainTransactionEntity> getMainTransactionsForToday()  =>
      hiveLocalDataSource.getMainTransactionsForToday();

  @override
  List<MainTransactionEntity> fetchMainTransactionsForDay(DateTime selectedDate,List<MainTransactionEntity> totalTransactions)  =>
      hiveLocalDataSource.fetchMainTransactionsForDay(selectedDate,totalTransactions);

  @override
  List<MainTransactionEntity> fetchMainTransactionsForMonth(DateTime selectedDate,List<MainTransactionEntity> totalTransactions)  =>
      hiveLocalDataSource.fetchMainTransactionsForMonth(selectedDate,totalTransactions);
  @override
  List<MainTransactionEntity> fetchMainTransactionsForWeek(
          DateTime selectedDate,List<MainTransactionEntity> totalTransactions)  =>
      hiveLocalDataSource.fetchMainTransactionsForWeek(selectedDate,totalTransactions);

  @override
  List<MainTransactionEntity> fetchMainTransactionsForYear(DateTime selectedDate,List<MainTransactionEntity> totalTransactions)  =>
      hiveLocalDataSource.fetchMainTransactionsForYear(selectedDate,totalTransactions);
      
}
