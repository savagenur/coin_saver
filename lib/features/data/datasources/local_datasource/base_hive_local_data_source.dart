import '../../../domain/entities/account/account_entity.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/entities/currency/currency_entity.dart';
import '../../../domain/entities/transaction/transaction_entity.dart';

abstract class BaseHiveLocalDataSource {
  // Hive
  Future<void> initHiveAdaptersBoxes();
  Future<void> initHive();
  // Account
  Future<List<AccountEntity>> getAccounts();
  Future<void> putAccounts(List<AccountEntity> accounts);
  Future<void> createAccount(AccountEntity accountEntity);
  Future<void> updateAccount(AccountEntity accountEntity);

  Future<void> deleteAccount(String id);
  Future<void> setPrimaryAccount(String accountId);

  // Transaction
  Future<void> addTransaction({
    required AccountEntity accountEntity,
    required TransactionEntity transactionEntity,
  });
  Future<void> deleteTransaction({
    required TransactionEntity transactionEntity,
    required AccountEntity accountEntity,
  });
  Future<void> updateTransaction({
    required TransactionEntity transactionEntity,
    required AccountEntity accountEntity,
  });
  List<TransactionEntity> getTransactions();

  // Category
  Future<List<CategoryEntity>> getCategories();
  Future<void> createCategory(CategoryEntity categoryEntity);
  Future<void> updateCategory(int index, CategoryEntity categoryEntity);
  Future<void> deleteCategory(String categoryId);

  // Currency
  Future<CurrencyEntity> getCurrency();
  Future<void> createCurrency(CurrencyEntity currencyEntity);
  Future<void> updateCurrency(CurrencyEntity currencyEntity);

  // Selected Date Transactions
  List<TransactionEntity> getTransactionsForToday();
  List<TransactionEntity> fetchTransactionsForDay(
      DateTime selectedDate, List<TransactionEntity> totalTransactions);
  List<TransactionEntity> fetchTransactionsForWeek(
      DateTime selectedDate, List<TransactionEntity> totalTransactions);
  List<TransactionEntity> fetchTransactionsForMonth(
      DateTime selectedDate, List<TransactionEntity> totalTransactions);
  List<TransactionEntity> fetchTransactionsForYear(
      DateTime selectedDate, List<TransactionEntity> totalTransactions);
}
