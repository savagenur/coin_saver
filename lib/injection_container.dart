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
import 'package:coin_saver/features/domain/usecases/time_period/fetch_transactions_for_day_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/main_transaction/main_transaction_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/time_period/time_period_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/domain/usecases/category/create_category_usecase.dart';
import 'features/domain/usecases/category/delete_category_usecase.dart';
import 'features/domain/usecases/category/get_categories_usecase.dart';
import 'features/domain/usecases/category/update_category_usecase.dart';
import 'features/domain/usecases/main_time_period/fetch_main_transactions_for_day_usecase.dart';
import 'features/domain/usecases/main_time_period/fetch_main_transactions_for_month_usecase.dart';
import 'features/domain/usecases/main_time_period/fetch_main_transactions_for_week_usecase.dart';
import 'features/domain/usecases/main_time_period/fetch_main_transactions_for_year_usecase.dart';
import 'features/domain/usecases/main_time_period/get_main_transactions_for_today_usecase.dart';
import 'features/domain/usecases/main_transaction/create_main_transaction_usecase.dart';
import 'features/domain/usecases/main_transaction/delete_main_transaction_usecase.dart';
import 'features/domain/usecases/time_period/fetch_transactions_for_month_usecase.dart';
import 'features/domain/usecases/time_period/fetch_transactions_for_week_usecase.dart';
import 'features/domain/usecases/time_period/fetch_transactions_for_year_usecase.dart';
import 'features/presentation/bloc/main_time_period/main_time_period_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // * Blocs
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
  sl.registerFactory(
    () => CategoryBloc(
        getCategoriesUsecase: sl.call(),
        createCategoryUsecase: sl.call(),
        updateCategoryUsecase: sl.call(),
        deleteCategoryUsecase: sl.call()),
  );
  sl.registerFactory(
    () => TimePeriodBloc(
      fetchTransactionsForDayUsecase: sl.call(),
      fetchTransactionsForWeekUsecase: sl.call(),
      fetchTransactionsForMonthUsecase: sl.call(),
      fetchTransactionsForYearUsecase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => MainTimePeriodBloc(
      fetchMainTransactionsForDayUsecase: sl.call(),
      fetchMainTransactionsForWeekUsecase: sl.call(),
      fetchMainTransactionsForMonthUsecase: sl.call(),
      fetchMainTransactionsForYearUsecase: sl.call(),
      getMainTransactionsForTodayUsecase: sl.call(),
      getMainTransactionsUsecase: sl.call(),
    ),
  );
// * Account usecases
  sl.registerLazySingleton(() => CreateAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetAccountsUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SelectAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => InitHiveUsecase(repository: sl.call()));

// * MainTransaction usecases
  sl.registerLazySingleton(
      () => GetMainTransactionsUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => UpdateMainTransactionUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => CreateMainTransactionUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => DeleteMainTransactionUsecase(repository: sl.call()));

// * Category usecases
  sl.registerLazySingleton(() => GetCategoriesUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCategoryUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateCategoryUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCategoryUsecase(repository: sl.call()));

// * Currency usecases

// * Time Period usecases
  sl.registerLazySingleton(
      () => FetchTransactionsForDayUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FetchTransactionsForWeekUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FetchTransactionsForMonthUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FetchTransactionsForYearUsecase(repository: sl.call()));

// * Main Time Period usecases
  sl.registerLazySingleton(
      () => GetMainTransactionsForTodayUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FetchMainTransactionsForDayUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FetchMainTransactionsForWeekUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FetchMainTransactionsForMonthUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FetchMainTransactionsForYearUsecase(repository: sl.call()));

// * Hive repositories
  sl.registerLazySingleton<BaseHiveRepository>(
      () => HiveRepository(hiveLocalDataSource: sl.call()));
  sl.registerLazySingleton<BaseHiveLocalDataSource>(
      () => HiveLocalDataSource());
}
