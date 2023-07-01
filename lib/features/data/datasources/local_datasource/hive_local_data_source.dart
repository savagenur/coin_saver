import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/data/datasources/local_datasource/base_hive_local_data_source.dart';
import 'package:coin_saver/features/data/models/account/account_model.dart';
import 'package:coin_saver/features/data/models/category/category_model.dart';
import 'package:coin_saver/features/data/models/currency/currency_model.dart';
import 'package:coin_saver/features/data/models/main_transaction/main_transaction_model.dart';
import 'package:coin_saver/features/data/models/transaction/transaction_model.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class HiveLocalDataSource implements BaseHiveLocalDataSource {
  final Uuid uuid = Uuid();
  @override
  Future<void> createAccount(AccountEntity accountEntity) async {
    String id = uuid.v1();
    Box box = await Hive.openBox<AccountModel>(BoxConst.accounts);
    await box.put(
      id,
      AccountEntity(
          id: id,
          name: accountEntity.name,
          type: accountEntity.type,
          balance: accountEntity.balance,
          currency: accountEntity.currency,
          isPrimary: true,
          isActive: true,
          ownershipType: accountEntity.ownershipType,
          openingDate: accountEntity.openingDate,
          transactionHistory: accountEntity.transactionHistory),
    );
  }

  @override
  Future<void> createCurrency(CurrencyEntity currencyEntity) async {
    Box box = await Hive.openBox<CurrencyModel>(BoxConst.currency);
    await box.put(
        0,
        CurrencyModel(
            code: currencyEntity.code,
            name: currencyEntity.name,
            symbol: currencyEntity.symbol));
  }

  @override
  Future<void> createMainTransaction(
      MainTransactionEntity mainTransactionEntity) async {
    Box box =
        await Hive.openBox<MainTransactionModel>(BoxConst.mainTransactions);

    if (box.containsKey(mainTransactionEntity.name)) {
      MainTransactionModel oldMainTransactionModel =
          await box.get(mainTransactionEntity.name);
      await box.put(
        mainTransactionEntity.name,
        MainTransactionModel(
            id: mainTransactionEntity.name,
            accountId: mainTransactionEntity.accountId,
            name: mainTransactionEntity.name,
            iconData: mainTransactionEntity.iconData,
            color: mainTransactionEntity.color,
            totalAmount: oldMainTransactionModel.totalAmount +
                mainTransactionEntity.totalAmount,
            dateTime: mainTransactionEntity.dateTime),
      );
    } else {
      await box.put(
        mainTransactionEntity.name,
        MainTransactionModel(
            id: mainTransactionEntity.name,
            accountId: mainTransactionEntity.accountId,
            name: mainTransactionEntity.name,
            iconData: mainTransactionEntity.iconData,
            color: mainTransactionEntity.color,
            totalAmount: mainTransactionEntity.totalAmount,
            dateTime: mainTransactionEntity.dateTime),
      );
    }
  }

  @override
  Future<void> deleteAccount(String id) async {
    Box box = await Hive.openBox<AccountModel>(BoxConst.accounts);
    await box.delete(id);
  }

  @override
  Future<void> deleteMainTransaction(String id) async {
    Box box =
        await Hive.openBox<MainTransactionModel>(BoxConst.mainTransactions);
    await box.delete(id);
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    Box box = await Hive.openBox<AccountModel>(BoxConst.accounts);
    return box.values.toList().cast<AccountModel>();
  }

  @override
  Future<CurrencyEntity> getCurrency() async {
    Box box = await Hive.openBox<CurrencyModel>(BoxConst.currency);
    return box.getAt(0);
  }

  @override
  Future<List<MainTransactionEntity>> getMainTransactions() async {
    Box box =
        await Hive.openBox<MainTransactionModel>(BoxConst.mainTransactions);
    return box.values.toList().cast<MainTransactionModel>();
  }

  @override
  Future<void> initHive() async {
    Hive.registerAdapter<AccountType>(AccountTypeAdapter());
    Hive.registerAdapter<OwnershipType>(OwnershipTypeAdapter());
    Hive.registerAdapter<PaymentType>(PaymentTypeAdapter());
    Hive.registerAdapter<CategoryModel>(CategoryModelAdapter());
    Hive.registerAdapter<CurrencyModel>(CurrencyModelAdapter());
    Hive.registerAdapter<AccountModel>(AccountModelAdapter());
    Hive.registerAdapter<MainTransactionModel>(MainTransactionModelAdapter());
    Hive.registerAdapter<TransactionModel>(TransactionModelAdapter());

    Box accountsBox = await Hive.openBox<AccountModel>(BoxConst.accounts);
    Box currencyBox = await Hive.openBox<CurrencyModel>(BoxConst.currency);
    if (currencyBox.isEmpty) {
      await currencyBox.put(
          0,
          CurrencyModel(
              code: "USD", name: "United States Dollar", symbol: "\$"));
      await accountsBox.put(
          "total",
          AccountModel(
              id: "total",
              name: "Total",
              type: AccountType.cash,
              balance: 0,
              currency: currencyBox.getAt(0),
              isPrimary: false,
              isActive: true,
              ownershipType: OwnershipType.individual,
              openingDate: DateTime.now(),
              transactionHistory: const []));
      await accountsBox.put(
          "main",
          AccountModel(
              id: "main",
              name: "Main",
              type: AccountType.cash,
              balance: 0,
              currency: currencyBox.getAt(0),
              isPrimary: true,
              isActive: true,
              ownershipType: OwnershipType.individual,
              openingDate: DateTime.now(),
              transactionHistory: const []));
    }
    
  }

  @override
  Future<void> updateAccount(AccountEntity accountEntity) async {
    Box accountsBox = await Hive.openBox<AccountModel>(BoxConst.accounts);
    String id = uuid.v1();
    await accountsBox.put(
        accountEntity.id,
        AccountModel(
            id: id,
            name: accountEntity.name,
            type: accountEntity.type,
            balance: accountEntity.balance,
            currency: accountEntity.currency,
            isPrimary: accountEntity.isPrimary,
            isActive: accountEntity.isActive,
            ownershipType: accountEntity.ownershipType,
            openingDate: accountEntity.openingDate,
            transactionHistory: accountEntity.transactionHistory));
    ;
  }

  @override
  Future<void> updateCurrency(CurrencyEntity currencyEntity) async {
    Box box = await Hive.openBox<CurrencyModel>(BoxConst.currency);
    await box.put(
        0,
        CurrencyModel(
            code: currencyEntity.code,
            name: currencyEntity.name,
            symbol: currencyEntity.symbol));
  }

  @override
  Future<void> updateMainTransaction(
      String oldKey, MainTransactionEntity mainTransactionEntity) async {
    Box box =
        await Hive.openBox<MainTransactionModel>(BoxConst.mainTransactions);
    MainTransactionModel oldMainTransactionModel = await box.get(oldKey);
    await box.put(
        mainTransactionEntity.name,
        MainTransactionModel(
            id: mainTransactionEntity.name,
            accountId: mainTransactionEntity.accountId,
            name: mainTransactionEntity.name,
            iconData: mainTransactionEntity.iconData,
            color: mainTransactionEntity.color,
            totalAmount: oldMainTransactionModel.totalAmount,
            dateTime: oldMainTransactionModel.dateTime));
    await box.delete(oldKey);
  }
}
