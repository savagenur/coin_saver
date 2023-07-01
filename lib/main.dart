import 'package:coin_saver/features/data/datasources/local_datasource/base_hive_local_data_source.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';
import 'package:coin_saver/features/domain/usecases/hive/init_hive_usecase.dart';
import 'package:coin_saver/routes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'constants/constants.dart';
import 'features/data/models/account/account_model.dart';
import 'features/data/models/category/category_model.dart';
import 'features/data/models/currency/currency_model.dart';
import 'features/data/models/main_transaction/main_transaction_model.dart';
import 'features/data/models/transaction/transaction_model.dart';
import 'features/presentation/pages/home/home_page.dart';
import 'injection_container.dart' as di;

void main() async {
  await Hive.initFlutter();
  await di.init();

  
  await di.sl<InitHiveUsecase>().call();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: FlexThemeData.light(scheme: FlexScheme.brandBlue),
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
      },
      onGenerateRoute: AppRoute().onGenerateRoute,
    );
  }
}
