import '../../../domain/entities/account/account_entity.dart';
import '../../../domain/entities/currency/currency_entity.dart';
import '../../../domain/entities/main_transaction/main_transaction_entity.dart';

abstract class BaseHiveLocalDataSource {
  Future<void> initHive();
  // Account
  Future<List<AccountEntity>> getAccounts();
  Future<void> putAccounts(List<AccountEntity> accounts);
  Future<void> createAccount(AccountEntity accountEntity);
  Future<void> updateAccount(AccountEntity accountEntity);
  Future<void> selectAccount(AccountEntity accountEntity,List<AccountEntity> accounts);
  Future<void> deleteAccount(String id);

  // MainTransaction
  Future<List<MainTransactionEntity>> getMainTransactions();
  Future<void> createMainTransaction(
      MainTransactionEntity mainTransactionEntity);
  Future<void> updateMainTransaction(
      String oldKey, MainTransactionEntity mainTransactionEntity);
  Future<void> deleteMainTransaction(String id);

  // Currency
  Future<CurrencyEntity> getCurrency();
  Future<void> createCurrency(CurrencyEntity currencyEntity);
  Future<void> updateCurrency(CurrencyEntity currencyEntity);
}
