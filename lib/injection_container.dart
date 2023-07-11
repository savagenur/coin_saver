import 'package:coin_saver/features/data/datasources/local_datasource/base_hive_local_data_source.dart';
import 'package:coin_saver/features/data/datasources/local_datasource/hive_local_data_source.dart';
import 'package:coin_saver/features/data/repositories/hive_repository.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';
import 'package:coin_saver/features/domain/usecases/account/create_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/delete_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/get_accounts_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/select_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/set_primary_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/add_transaction_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/update_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/hive/init_hive_usecase.dart';
import 'package:coin_saver/features/domain/usecases/main_transaction/get_main_transactions_usecase.dart';
import 'package:coin_saver/features/domain/usecases/main_transaction/update_main_transaction_usecase.dart';
import 'package:coin_saver/features/domain/usecases/time_period/fetch_transactions_for_day_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_category/selected_category_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_icon/selected_icon_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/time_period/time_period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/main_transaction/main_transaction_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'features/domain/usecases/account/transaction/delete_transaction_usecase.dart';
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
import 'features/presentation/bloc/cubit/main_colors/main_colors_cubit.dart';
import 'features/presentation/bloc/cubit/selected_color/selected_color_cubit.dart';
import 'features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'features/presentation/bloc/main_time_period/main_time_period_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // * Blocs
  getIt.registerFactory(() => AccountBloc(
      createAccountUsecase: getIt.call(),
      getAccountsUsecase: getIt.call(),
      updateAccountUsecase: getIt.call(),
      setPrimaryAccountUsecase: getIt.call(),
      addTransactionUsecase: getIt.call(),
      deleteTransactionUsecase: getIt.call(),
      deleteAccountUsecase: getIt.call()));

  getIt.registerFactory(
    () => MainTransactionBloc(
      getMainTransactionsUsecase: getIt.call(),
      createMainTransactionUsecase: getIt.call(),
      updateMainTransactionUsecase: getIt.call(),
      deleteMainTransactionUsecase: getIt.call(),
    ),
  );
  getIt.registerFactory(
    () => CategoryBloc(
        getCategoriesUsecase: getIt.call(),
        createCategoryUsecase: getIt.call(),
        updateCategoryUsecase: getIt.call(),
        deleteCategoryUsecase: getIt.call()),
  );

  getIt.registerFactory(
    () => MainTimePeriodBloc(
      fetchMainTransactionsForDayUsecase: getIt.call(),
      fetchMainTransactionsForWeekUsecase: getIt.call(),
      fetchMainTransactionsForMonthUsecase: getIt.call(),
      fetchMainTransactionsForYearUsecase: getIt.call(),
      getMainTransactionsForTodayUsecase: getIt.call(),
      getMainTransactionsUsecase: getIt.call(),
    ),
  );
  getIt.registerFactory(
    () => TimePeriodCubit(
      fetchTransactionsForDayUsecase: getIt.call(),
      fetchTransactionsForWeekUsecase: getIt.call(),
      fetchTransactionsForMonthUsecase: getIt.call(),
      fetchTransactionsForYearUsecase: getIt.call(),
    ),
  );
  getIt.registerFactory(
    () => PeriodCubit(),
  );
  getIt.registerFactory(
    () => SelectedDateCubit(),
  );
  getIt.registerFactory(
    () => SelectedCategoryCubit(),
  );
  getIt.registerFactory(
    () => SelectedIconCubit(),
  );
  getIt.registerFactory(
    () => SelectedColorCubit(),
  );
  getIt.registerFactory(
    () => MainColorsCubit(),
  );

// * Account usecases
  getIt.registerLazySingleton(
      () => CreateAccountUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => GetAccountsUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => UpdateAccountUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => SelectAccountUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => DeleteAccountUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => SetPrimaryAccountUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(() => InitHiveUsecase(repository: getIt.call()));

// * Transaction
  getIt.registerLazySingleton(
      () => AddTransactionUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => DeleteTransactionUsecase(repository: getIt.call()));

// * MainTransaction usecases
  getIt.registerLazySingleton(
      () => GetMainTransactionsUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => UpdateMainTransactionUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => CreateMainTransactionUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => DeleteMainTransactionUsecase(repository: getIt.call()));

// * Category usecases
  getIt.registerLazySingleton(
      () => GetCategoriesUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => UpdateCategoryUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => CreateCategoryUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => DeleteCategoryUsecase(repository: getIt.call()));

// * Currency usecases

// * Time Period usecases
  getIt.registerLazySingleton(
      () => FetchTransactionsForDayUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => FetchTransactionsForWeekUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => FetchTransactionsForMonthUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => FetchTransactionsForYearUsecase(repository: getIt.call()));

// * Main Time Period usecases
  getIt.registerLazySingleton(
      () => GetMainTransactionsForTodayUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => FetchMainTransactionsForDayUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => FetchMainTransactionsForWeekUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => FetchMainTransactionsForMonthUsecase(repository: getIt.call()));
  getIt.registerLazySingleton(
      () => FetchMainTransactionsForYearUsecase(repository: getIt.call()));

// * Hive repositories
  getIt.registerLazySingleton<BaseHiveRepository>(
      () => HiveRepository(hiveLocalDataSource: getIt.call()));
  getIt.registerLazySingleton<BaseHiveLocalDataSource>(
      () => HiveLocalDataSource());
  getIt.registerLazySingleton(() => const Uuid());
}
