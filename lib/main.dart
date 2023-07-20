import 'package:coin_saver/features/domain/usecases/hive/init_hive_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/transaction_period/transaction_period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/currency/currency_bloc.dart';
import 'package:coin_saver/routes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'features/domain/usecases/hive/init_hive_adapters_boxes_usecase.dart';
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
import 'observer.dart';

void main() async {
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

  await sl<InitHiveAdaptersBoxesUsecase>().call();
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: FlexThemeData.light(scheme: FlexScheme.brandBlue),
        initialRoute: "/",
        routes: {
          "/": (context) => const HomePage(),
        },
        onGenerateRoute: AppRoute().onGenerateRoute,
      ),
    );
  }
}
