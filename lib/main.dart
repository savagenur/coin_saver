import 'package:coin_saver/features/data/datasources/local_datasource/base_hive_local_data_source.dart';
import 'package:coin_saver/features/domain/usecases/hive/init_hive_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/main_transaction/main_transaction_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/time_period/time_period_bloc.dart';
import 'package:coin_saver/routes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'features/presentation/bloc/main_time_period/main_time_period_bloc.dart';
import 'features/presentation/pages/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'observer.dart';

void main() async {
  await Hive.initFlutter();
  await di.init();
  // Bloc.observer = const MainTransactionObserver();
  Future<void> removeHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();

    // Close all open Hive boxes
    await Hive.close();

    // Delete all the Hive files
    await appDocumentDir.delete(recursive: true);
  }

  await di.sl<InitHiveUsecase>().call();
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
          create: (_) => di.sl<AccountBloc>()..add(GetAccounts()),
        ),
        BlocProvider(
          create: (_) =>
              di.sl<MainTransactionBloc>()..add(GetMainTransactions()),
        ),
        BlocProvider(
          create: (_) => di.sl<CategoryBloc>()..add(GetCategories()),
        ),
        BlocProvider(
          create: (_) => di.sl<TimePeriodBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<MainTimePeriodBloc>()..add(GetTodayPeriod()),
        ),
        BlocProvider(
          create: (_) => di.sl<PeriodCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<SelectedDateCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: FlexThemeData.light(scheme: FlexScheme.brandBlue),
        initialRoute: "/",
        routes: {
          "/": (context) => HomePage(),
        },
        onGenerateRoute: AppRoute().onGenerateRoute,
      ),
    );
  }
}
