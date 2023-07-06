import 'package:coin_saver/features/data/models/account/account_model.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';

abstract class BaseHiveRepository {
  Future<void> initHive();
  // Account
  Future<List<AccountEntity>> getAccounts();
  Future<void> putAccounts(List<AccountEntity> accounts);
  Future<void> createAccount(AccountEntity accountEntity);
  Future<void> selectAccount(
      AccountEntity accountEntity, List<AccountEntity> accounts);
  Future<void> updateAccount(AccountEntity accountEntity);
  Future<void> deleteAccount(String id);

  // MainTransaction
  Future<List<MainTransactionEntity>> getMainTransactions();
  Future<void> createMainTransaction(
      MainTransactionEntity mainTransactionEntity);
  Future<void> updateMainTransaction(
      String oldKey, MainTransactionEntity mainTransactionEntity);
  Future<void> deleteMainTransaction(String id);

  // Category
  Future<List<CategoryEntity>> getCategories();
  Future<void> createCategory(CategoryEntity categoryEntity);
  Future<void> updateCategory(int index, CategoryEntity categoryEntity);
  Future<void> deleteCategory(int index);

  // Currency
  Future<CurrencyEntity> getCurrency();
  Future<void> createCurrency(CurrencyEntity currencyEntity);
  Future<void> updateCurrency(CurrencyEntity currencyEntity);

  // Selected Date Transactions
  List<TransactionEntity> getTransactionsForToday();
  List<TransactionEntity> fetchTransactionsForDay(DateTime selectedDate, List<TransactionEntity> totalTransactions);
  List<TransactionEntity> fetchTransactionsForWeek(DateTime selectedDate, List<TransactionEntity> totalTransactions);
  List<TransactionEntity> fetchTransactionsForMonth(DateTime selectedDate, List<TransactionEntity> totalTransactions);
  List<TransactionEntity> fetchTransactionsForYear(DateTime selectedDate, List<TransactionEntity> totalTransactions);

  // Date MainTransactions
  List<MainTransactionEntity> getMainTransactionsForToday();
  List<MainTransactionEntity> fetchMainTransactionsForDay(DateTime selectedDate, List<MainTransactionEntity> totalMainTransactions);
  List<MainTransactionEntity> fetchMainTransactionsForWeek(DateTime selectedDate, List<MainTransactionEntity> totalTransactions);
  List<MainTransactionEntity> fetchMainTransactionsForMonth(DateTime selectedDate, List<MainTransactionEntity> totalMainTransactions);
  List<MainTransactionEntity> fetchMainTransactionsForYear(DateTime selectedDate, List<MainTransactionEntity> totalMainTransactions);

}
