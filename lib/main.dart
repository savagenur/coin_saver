import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/data/models/currency/currency_model.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/usecases/hive/init_hive_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/transaction_period/transaction_period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/currency/currency_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/reminder/reminder_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/settings/settings_bloc.dart';
import 'package:coin_saver/features/presentation/pages/welcome_chapter/welcome/welcome_page.dart';
import 'package:coin_saver/routes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'features/presentation/bloc/cubit/main_colors/main_colors_cubit.dart';
import 'features/presentation/bloc/cubit/selected_category/selected_category_cubit.dart';
import 'features/presentation/bloc/cubit/selected_color/selected_color_cubit.dart';
import 'features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'features/presentation/bloc/cubit/selected_icon/selected_icon_cubit.dart';
import 'features/presentation/bloc/home_time_period/home_time_period_bloc.dart';
import 'features/presentation/bloc/main_transaction/main_transaction_bloc.dart';
import 'features/presentation/pages/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initGetIt();

  // Bloc.observer = const MainTransactionObserver();

  Future<void> removeHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();

    // Close all open Hive boxes
    await Hive.close();

    // Delete all the Hive files
    await appDocumentDir.delete(recursive: true);
  }

  // await sl<InitHiveAdaptersBoxesUsecase>().call();
  await sl<InitHiveUsecase>().call();
  // await removeHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AccountBloc>()..add(GetAccounts()),
        ),
        BlocProvider(
          create: (_) => sl<CategoryBloc>()..add(GetCategories()),
        ),
        BlocProvider(
          create: (_) => sl<CurrencyBloc>()..add(GetCurrency()),
        ),
        BlocProvider(
          create: (_) => sl<MainTransactionBloc>()..add(GetTransactions()),
        ),
        BlocProvider(
          create: (_) => sl<HomeTimePeriodBloc>()..add(GetTodayPeriod()),
        ),
        BlocProvider(
          create: (_) => sl<ReminderBloc>()..add(const GetReminders()),
        ),
        BlocProvider(
          create: (_) => sl<TransactionPeriodCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<PeriodCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<SelectedDateCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<SelectedCategoryCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<SelectedIconCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<SelectedColorCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<MainColorsCubit>()..getMainColors(),
        ),
        BlocProvider(
          create: (_) => sl<SettingsBloc>()..add(const GetSettings()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          Intl.defaultLocale = settingsState.language;
          final bool isFirstInit =
              Hive.box<CurrencyModel>(BoxConst.currency).isEmpty;

          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            locale: settingsState.language == null
                ? null
                : Locale(settingsState.language ?? "en"),
            supportedLocales: L10n.all,
            debugShowCheckedModeBanner: false,
            title: "Coin Saver",
            theme: settingsState.isDarkTheme
                ? FlexThemeData.dark(scheme: FlexScheme.brandBlue)
                : FlexThemeData.light(scheme: FlexScheme.brandBlue),
            initialRoute: "/",
            routes: {
              "/": (context) =>
                  isFirstInit ? const WelcomePage() : const HomePage(),
            },
            onGenerateRoute: AppRoute().onGenerateRoute,
          );
        },
      ),
    );
  }
}
