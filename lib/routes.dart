import 'package:coin_saver/features/presentation/pages/add_category/add_category_page.dart';
import 'package:coin_saver/features/presentation/pages/add_transaction/add_transaction_page.dart';
import 'package:coin_saver/features/presentation/pages/catalog_icons/catalog_icons_page.dart';
import 'package:coin_saver/features/presentation/pages/colors/colors_page.dart';
import 'package:coin_saver/features/presentation/pages/home/home_page.dart';
import 'package:coin_saver/features/presentation/pages/main_transaction/main_transaction_page.dart';
import 'package:coin_saver/features/presentation/pages/transaction_detail/transaction_detail_page.dart';
import 'package:coin_saver/features/presentation/transactions/transactions_page.dart';
import 'package:flutter/material.dart';

import 'constants/constants.dart';
import 'features/presentation/pages/create_category/create_category_page.dart';

class AppRoute {
  Route onGenerateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case PageConst.homePage:
        args = args as HomePage;

        return _routeBuilder(HomePage(
          dateTime: args.dateTime,
          isIncome: args.isIncome,
        ));
      case PageConst.addTransactionPage:
        args = args as AddTransactionPage;

        return _routeBuilder(AddTransactionPage(
          isIncome: args.isIncome,
          account: args.account,
          selectedDate: args.selectedDate,
        ));
      case PageConst.catalogIconsPage:
        return _routeBuilder(CatalogIconsPage());
      case PageConst.colorsPage:
        return _routeBuilder(ColorsPage());
      case PageConst.createCategoryPage:
        args = args as CreateCategoryPage;

        return _routeBuilder(CreateCategoryPage(
          isIncome: args.isIncome,
        ));
      case PageConst.transactionsPage:
        args = args as TransactionsPage;
        return _routeBuilder(TransactionsPage(
          account: args.account,
        ));
      case PageConst.mainTransactionPage:
        args = args as MainTransactionPage;

        return _routeBuilder(MainTransactionPage(
          mainTransaction: args.mainTransaction,
        ));
      case PageConst.transactionDetailPage:
        args = args as TransactionDetailPage;

        return _routeBuilder(TransactionDetailPage(
          transaction: args.transaction,
          account: args.account,
        ));
      case PageConst.addCategoryPage:
        args = args as AddCategoryPage;
        return _routeBuilder(AddCategoryPage(
          isIncome: args.isIncome,
        ));
      default:
        return _routeBuilder(const NotFoundPage());
    }
  }

  MaterialPageRoute _routeBuilder(Widget child) {
    return MaterialPageRoute(
      builder: (context) => child,
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Page not found!"),
    );
  }
}
