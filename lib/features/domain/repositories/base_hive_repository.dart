import 'package:coin_saver/features/data/models/account/account_model.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';

abstract class BaseHiveRepository {
  Future<void> initHive();
  // Account
  Future<List<AccountEntity>> getAccounts();
  Future<void> createAccount(AccountEntity accountEntity);
  Future<void> updateAccount(AccountEntity accountEntity);
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
