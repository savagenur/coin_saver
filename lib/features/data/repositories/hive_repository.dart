import 'package:coin_saver/features/data/datasources/local_datasource/base_hive_local_data_source.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class HiveRepository implements BaseHiveRepository {
  final BaseHiveLocalDataSource hiveLocalDataSource;
  HiveRepository({
    required this.hiveLocalDataSource,
  });
  @override
  Future<void> createAccount(AccountEntity accountEntity) async =>
      hiveLocalDataSource.createAccount(accountEntity);

  @override
  Future<void> createCurrency(CurrencyEntity currencyEntity) async =>
      hiveLocalDataSource.createCurrency(currencyEntity);

  @override
  Future<void> createMainTransaction(
          MainTransactionEntity mainTransactionEntity) async =>
      hiveLocalDataSource.createMainTransaction(mainTransactionEntity);

  @override
  Future<void> deleteAccount(String id) async =>
      hiveLocalDataSource.deleteAccount(id);

  @override
  Future<void> deleteMainTransaction(String id) async =>
      hiveLocalDataSource.deleteMainTransaction(id);

  @override
  Future<List<AccountEntity>> getAccounts() async =>
      hiveLocalDataSource.getAccounts();

  @override
  Future<CurrencyEntity> getCurrency() async =>
      hiveLocalDataSource.getCurrency();

  @override
  Future<List<MainTransactionEntity>> getMainTransactions() async =>
      hiveLocalDataSource.getMainTransactions();

  @override
  Future<void> initHive() async => hiveLocalDataSource.initHive();

  @override
  Future<void> updateAccount(AccountEntity accountEntity) async =>
      hiveLocalDataSource.updateAccount(accountEntity);

  @override
  Future<void> selectAccount(AccountEntity accountEntity,List<AccountEntity> accounts) async =>
      hiveLocalDataSource.selectAccount(accountEntity,accounts);

  @override
  Future<void> updateCurrency(CurrencyEntity currencyEntity) async =>
      hiveLocalDataSource.updateCurrency(currencyEntity);

  @override
  Future<void> updateMainTransaction(
          String oldKey, MainTransactionEntity mainTransactionEntity) async =>
      hiveLocalDataSource.updateMainTransaction(oldKey, mainTransactionEntity);

  @override
  Future<void> putAccounts(List<AccountEntity> accounts) async =>
      hiveLocalDataSource.putAccounts(accounts);
}
