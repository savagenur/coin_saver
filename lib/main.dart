import 'dart:io';

import 'package:coin_saver/constants/theme.dart';
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
import 'package:path_provider/path_provider.dart';

import 'features/presentation/bloc/cubit/main_colors/main_colors_cubit.dart';
import 'features/presentation/bloc/cubit/selected_category/selected_category_cubit.dart';
import 'features/presentation/bloc/cubit/selected_color/selected_color_cubit.dart';
import 'features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'features/presentation/bloc/cubit/selected_icon/selected_icon_cubit.dart';
import 'features/presentation/bloc/home_time_period/home_time_period_bloc.dart';
import 'features/presentation/pages/home/home_page.dart';
import 'injection_container.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initGetIt();
  await sl<InitHiveUsecase>().call(); 
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
