import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/constants/main_categories.dart';
import 'package:coin_saver/constants/theme.dart';
import 'package:coin_saver/features/data/models/currency/currency_model.dart';
import 'package:coin_saver/features/domain/usecases/hive/init_hive_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/first_launch/first_launch_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/rate_my_app/rate_my_app_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/transaction_period/transaction_period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/currency/currency_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/reminder/reminder_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/settings/settings_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:coin_saver/features/presentation/pages/welcome_chapter/welcome/welcome_page.dart';
import 'package:coin_saver/features/presentation/widgets/rate_app_init_widget.dart';
import 'package:coin_saver/features/presentation/widgets/splash_screen.dart';
import 'package:coin_saver/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

import 'features/data/models/category/category_model.dart';
import 'features/presentation/bloc/cubit/main_colors/main_colors_cubit.dart';
import 'features/presentation/bloc/cubit/selected_category/selected_category_cubit.dart';
import 'features/presentation/bloc/cubit/selected_color/selected_color_cubit.dart';
import 'features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'features/presentation/bloc/cubit/selected_icon/selected_icon_cubit.dart';
import 'features/presentation/bloc/home_time_period/home_time_period_bloc.dart';
import 'features/presentation/pages/home/home_page.dart';
import 'injection_container.dart';
import 'l10n/l10n.dart';
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
          create: (_) => sl<AccountBloc>()..add(const GetAccounts()),
        ),
        BlocProvider(
          create: (_) => sl<TransactionBloc>()..add(const GetTransactions()),
        ),
        BlocProvider(
          create: (_) => sl<CategoryBloc>()..add(GetCategories()),
        ),
        BlocProvider(
          create: (_) => sl<CurrencyBloc>()..add(GetCurrency()),
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
        BlocProvider(
          create: (_) => sl<RateMyAppCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<FirstLaunchCubit>()..getFirstLaunch(),
        ),
      ],
      child: BlocBuilder<FirstLaunchCubit, FirstLaunch>(
        builder: (context, firstLaunchState) {
          return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              Intl.defaultLocale =
                  settingsState.language ?? Platform.localeName;
              return MaterialApp(
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                locale: settingsState.language == null
                    ? null
                    : Locale(settingsState.language!),
                supportedLocales: L10n.all,
                debugShowCheckedModeBanner: false,
                title: "Coin Saver",
                theme: settingsState.isDarkTheme
                    ? MyAppTheme.darkTheme
                    : MyAppTheme.lightTheme,
                initialRoute: "/splash",
                routes: {
                  "/splash": (context) => RateAppInitWidget(
                        builder: (rateMyApp) {
                          return const SplashScreen();
                        },
                      ),
                  "/homePage": (context) => firstLaunchState.isFirstLaunch!
                      ? const WelcomePage()
                      : const HomePage(),
                },
                onGenerateRoute: AppRoute().onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
