import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coin_saver/features/data/datasources/local_datasource/currency/base_currency_local_data_source.dart';
import 'package:coin_saver/features/data/datasources/local_datasource/hive/base_hive_local_data_source.dart';
import 'package:coin_saver/features/data/datasources/local_datasource/hive/hive_local_data_source.dart';
import 'package:coin_saver/features/data/repositories/currency_repository.dart';
import 'package:coin_saver/features/data/repositories/hive_repository.dart';
import 'package:coin_saver/features/domain/repositories/base_currency_repository.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';
import 'package:coin_saver/features/domain/usecases/account/create_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/delete_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/get_accounts_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/set_primary_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/add_transaction_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/get_transactions_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/update_transaction_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/update_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/currency/get_currency_usecase.dart';
import 'package:coin_saver/features/domain/usecases/exchange_rates/get_exchange_rates_from_api_usecase.dart';
import 'package:coin_saver/features/domain/usecases/exchange_rates/get_exchange_rates_from_assets_usecase.dart';
import 'package:coin_saver/features/domain/usecases/exchange_rates/update_single_exchange_rate_from_api_usecase.dart';
import 'package:coin_saver/features/domain/usecases/hive/first_init_user_usecase.dart';
import 'package:coin_saver/features/domain/usecases/hive/get_first_launch_usecase.dart';
import 'package:coin_saver/features/domain/usecases/hive/init_hive_usecase.dart';
import 'package:coin_saver/features/domain/usecases/reminder/create_reminder_usecase.dart';
import 'package:coin_saver/features/domain/usecases/settings/delete_all_data_usecase.dart';
import 'package:coin_saver/features/domain/usecases/settings/get_settings_usecase.dart';
import 'package:coin_saver/features/domain/usecases/settings/update_language_usecase.dart';
import 'package:coin_saver/features/domain/usecases/settings/update_theme_usecase.dart';
import 'package:coin_saver/features/domain/usecases/time_period/fetch_transactions_for_day_usecase.dart';
import 'package:coin_saver/features/domain/usecases/time_period/get_transactions_for_today_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/first_launch/first_launch_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_category/selected_category_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_icon/selected_icon_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/transaction_period/transaction_period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/currency/currency_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/reminder/reminder_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/settings/settings_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import 'features/data/datasources/local_datasource/currency/currency_local_date_source.dart';
import 'features/domain/usecases/account/transaction/add_transfer_usecase.dart';
import 'features/domain/usecases/account/transaction/delete_transaction_usecase.dart';
import 'features/domain/usecases/account/transaction/delete_transfer_usecase.dart';
import 'features/domain/usecases/account/transaction/update_transfer_usecase.dart';
import 'features/domain/usecases/category/create_category_usecase.dart';
import 'features/domain/usecases/category/delete_category_usecase.dart';
import 'features/domain/usecases/category/get_categories_usecase.dart';
import 'features/domain/usecases/category/update_category_usecase.dart';
import 'features/domain/usecases/currency/create_currency_usecase.dart';
import 'features/domain/usecases/exchange_rates/convert_currency_usecase.dart';
import 'features/domain/usecases/hive/init_hive_adapters_boxes_usecase.dart';
import 'features/domain/usecases/reminder/delete_reminder_usecase.dart';
import 'features/domain/usecases/reminder/get_reminders_usecase.dart';
import 'features/domain/usecases/reminder/update_reminder_usecase.dart';
import 'features/domain/usecases/time_period/fetch_transactions_for_month_usecase.dart';
import 'features/domain/usecases/time_period/fetch_transactions_for_period_usecase.dart';
import 'features/domain/usecases/time_period/fetch_transactions_for_week_usecase.dart';
import 'features/domain/usecases/time_period/fetch_transactions_for_year_usecase.dart';
import 'features/presentation/bloc/cubit/main_colors/main_colors_cubit.dart';
import 'features/presentation/bloc/cubit/rate_my_app/rate_my_app_cubit.dart';
import 'features/presentation/bloc/cubit/selected_color/selected_color_cubit.dart';
import 'features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'features/presentation/bloc/home_time_period/home_time_period_bloc.dart';

final GetIt sl = GetIt.instance;
Future<void> initGetIt() async {
  // * Blocs
  sl.registerFactory(() => AccountBloc(
      createAccountUsecase: sl.call(),
      getAccountsUsecase: sl.call(),
      updateAccountUsecase: sl.call(),
      setPrimaryAccountUsecase: sl.call(),
      addTransactionUsecase: sl.call(),
      deleteTransactionUsecase: sl.call(),
      addTransferUsecase: sl.call(),
      updateTransferUsecase: sl.call(),
      deleteTransferUsecase: sl.call(),
      deleteAccountUsecase: sl.call(),
      updateTransactionUsecase: sl.call()));

  sl.registerFactory(
    () => CategoryBloc(
        getCategoriesUsecase: sl.call(),
        createCategoryUsecase: sl.call(),
        updateCategoryUsecase: sl.call(),
        deleteCategoryUsecase: sl.call()),
  );
  sl.registerFactory(
    () => SettingsBloc(
      getSettingsUsecase: sl.call(),
      updateLanguageUsecase: sl.call(),
      updateThemeUsecase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => RateMyAppCubit(),
  );
  sl.registerFactory(
    () => HomeTimePeriodBloc(
        fetchTransactionsForDayUsecase: sl.call(),
        getTransactionsForTodayUsecase: sl.call(),
        fetchTransactionsForWeekUsecase: sl.call(),
        fetchTransactionsForMonthUsecase: sl.call(),
        fetchTransactionsForYearUsecase: sl.call(),
        fetchTransactionsForPeriodUsecase: sl.call(),
        getTransactionsUsecase: sl.call()),
  );
  sl.registerFactory(
    () => CurrencyBloc(
        getCurrencyUsecase: sl.call(), createCurrencyUsecase: sl.call()),
  );
  sl.registerFactory(
    () => ReminderBloc(
        createReminderUsecase: sl.call(),
        deleteReminderUsecase: sl.call(),
        updateReminderUsecase: sl.call(),
        getRemindersUsecase: sl.call()),
  );

  // sl.registerFactory(
  //   () => MainTransactionBloc(
  //     getTransactionsUsecase: sl.call(),
  //     addTransactionUsecase: sl.call(),
  //     updateTransactionUsecase: sl.call(),
  //     deleteTransactionUsecase: sl.call(),
  //     setPrimaryAccountUsecase: sl.call(),
  //   ),
  // );

  sl.registerFactory(
    () => TransactionPeriodCubit(
      fetchTransactionsForDayUsecase: sl.call(),
      fetchTransactionsForWeekUsecase: sl.call(),
      fetchTransactionsForMonthUsecase: sl.call(),
      fetchTransactionsForYearUsecase: sl.call(),
      fetchTransactionsForPeriodUsecase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => PeriodCubit(),
  );
  sl.registerFactory(
    () => SelectedDateCubit(),
  );
  sl.registerFactory(
    () => FirstLaunchCubit(getFirstLaunchUsecase: sl.call()),
  );
  sl.registerFactory(
    () => SelectedCategoryCubit(),
  );
  sl.registerFactory(
    () => SelectedIconCubit(),
  );
  sl.registerFactory(
    () => SelectedColorCubit(),
  );
  sl.registerFactory(
    () => MainColorsCubit(),
  );

// * Hive usecases
  sl.registerLazySingleton(() => InitHiveUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => InitHiveAdaptersBoxesUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => FirstInitUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetFirstLaunchUsecase(repository: sl.call()));
// * Account usecases
  sl.registerLazySingleton(() => CreateAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetAccountsUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => SetPrimaryAccountUsecase(repository: sl.call()));

// * Currency usecases
  sl.registerLazySingleton(() => GetCurrencyUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateCurrencyUsecase(repository: sl.call()));

// * Settings usecases
  sl.registerLazySingleton(() => GetSettingsUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateLanguageUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateThemeUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteAllDataUsecase(repository: sl.call()));

// * Transaction usecases
  sl.registerLazySingleton(() => AddTransactionUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => AddTransferUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteTransferUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateTransferUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => DeleteTransactionUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => GetTransactionsForTodayUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetTransactionsUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => UpdateTransactionUsecase(repository: sl.call()));

// * Category usecases
  sl.registerLazySingleton(() => GetCategoriesUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCategoryUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateCategoryUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCategoryUsecase(repository: sl.call()));

// * Currency usecases

// * Reminder usecases
  sl.registerLazySingleton(() => CreateReminderUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetRemindersUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReminderUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReminderUsecase(repository: sl.call()));

// * ExchangeRate usecases
  sl.registerLazySingleton(
      () => GetExchangeRatesFromAssetsUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => GetExchangeRatesFromApiUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => ConvertCurrencyUsecase(repository: sl.call()));
sl.registerLazySingleton(() => UpdateSingleExchangeRateFromApiUsecase(repository: sl.call()));

// * Time Period usecases
  sl.registerLazySingleton(
      () => FetchTransactionsForDayUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FetchTransactionsForWeekUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FetchTransactionsForMonthUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FetchTransactionsForYearUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => FetchTransactionsForPeriodUsecase(repository: sl.call()));

// * Hive
  sl.registerLazySingleton<BaseHiveRepository>(
      () => HiveRepository(hiveLocalDataSource: sl.call()));
  sl.registerLazySingleton<BaseHiveLocalDataSource>(
      () => HiveLocalDataSource());

// Repository
  sl.registerLazySingleton<BaseCurrencyRepository>(
      () => CurrencyRepository(currencyLocalDataSource: sl.call()));

  sl.registerLazySingleton<BaseCurrencyLocalDataSource>(
      () => CurrencyLocalDataSource());

// Externals
  sl.registerLazySingleton(() => const Uuid());
  sl.registerLazySingleton(() => AwesomeNotifications());
}
