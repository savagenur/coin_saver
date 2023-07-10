import 'package:coin_saver/features/domain/usecases/hive/init_hive_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/time_period/time_period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/main_transaction/main_transaction_bloc.dart';
import 'package:coin_saver/routes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'features/presentation/bloc/cubit/main_colors/main_colors_cubit.dart';
import 'features/presentation/bloc/cubit/selected_category/selected_category_cubit.dart';
import 'features/presentation/bloc/cubit/selected_color/selected_color_cubit.dart';
import 'features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'features/presentation/bloc/cubit/selected_icon/selected_icon_cubit.dart';
import 'features/presentation/bloc/main_time_period/main_time_period_bloc.dart';
import 'features/presentation/pages/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart';
import 'observer.dart';

void main() async {
  await Hive.initFlutter();
  await init();
  // Bloc.observer = const MainTransactionObserver();
  Future<void> removeHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();

    // Close all open Hive boxes
    await Hive.close();

    // Delete all the Hive files
    await appDocumentDir.delete(recursive: true);
  }

  await getIt<InitHiveUsecase>().call();
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
          create: (_) => getIt<AccountBloc>()..add(GetAccounts()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<MainTransactionBloc>()..add(GetMainTransactions()),
        ),
        BlocProvider(
          create: (_) => getIt<CategoryBloc>()..add(GetCategories()),
        ),
        BlocProvider(
          create: (_) => getIt<MainTimePeriodBloc>()..add(GetTodayPeriod()),
        ),
        BlocProvider(
          create: (_) => getIt<TimePeriodCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<PeriodCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<SelectedDateCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<SelectedCategoryCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<SelectedIconCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<SelectedColorCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<MainColorsCubit>()..getMainColors(),
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
