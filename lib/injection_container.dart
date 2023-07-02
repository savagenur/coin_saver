import 'package:coin_saver/features/data/datasources/local_datasource/base_hive_local_data_source.dart';
import 'package:coin_saver/features/data/datasources/local_datasource/hive_local_data_source.dart';
import 'package:coin_saver/features/data/repositories/hive_repository.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';
import 'package:coin_saver/features/domain/usecases/account/create_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/delete_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/get_accounts_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/select_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/update_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/hive/init_hive_usecase.dart';
import 'package:coin_saver/features/domain/usecases/main_transaction/get_main_transactions_usecase.dart';
import 'package:coin_saver/features/domain/usecases/main_transaction/update_main_transaction_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/main_transaction/main_transaction_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/domain/usecases/main_transaction/create_main_transaction_usecase.dart';
import 'features/domain/usecases/main_transaction/delete_main_transaction_usecase.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => AccountBloc(
      createAccountUsecase: sl.call(),
      getAccountsUsecase: sl.call(),
      updateAccountUsecase: sl.call(),
      selectAccountUsecase: sl.call(),
      deleteAccountUsecase: sl.call()));

  sl.registerFactory(
    () => MainTransactionBloc(
      getMainTransactionsUsecase: sl.call(),
      createMainTransactionUsecase: sl.call(),
      updateMainTransactionUsecase: sl.call(),
      deleteMainTransactionUsecase: sl.call(),
    ),
  );
// Account usecases
  sl.registerLazySingleton(() => CreateAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetAccountsUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SelectAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => InitHiveUsecase(repository: sl.call()));
  
// MainTransaction usecases
  sl.registerLazySingleton(() => GetMainTransactionsUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateMainTransactionUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateMainTransactionUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteMainTransactionUsecase(repository: sl.call()));

// Currency usecases


  sl.registerLazySingleton<BaseHiveRepository>(
      () => HiveRepository(hiveLocalDataSource: sl.call()));
  sl.registerLazySingleton<BaseHiveLocalDataSource>(
      () => HiveLocalDataSource());
}
