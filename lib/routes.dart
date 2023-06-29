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
        return _routeBuilder(HomePage());
      case PageConst.addTransactionPage:
        return _routeBuilder(AddTransactionPage());
      case PageConst.catalogIconsPage:
        return _routeBuilder(CatalogIconsPage());
      case PageConst.colorsPage:
        return _routeBuilder(ColorsPage());
      case PageConst.createCategoryPage:
        return _routeBuilder(CreateCategoryPage());
      case PageConst.transactionsPage:
        return _routeBuilder(TransactionsPage());
      case PageConst.mainTransactionPage:
        return _routeBuilder(MainTransactionPage());
      case PageConst.transactionDetailPage:
        return _routeBuilder(TransactionDetailPage());
      case PageConst.addCategoryPage:
        args = args as AddCategoryPage;
        return _routeBuilder(AddCategoryPage(isIncome: args.isIncome,));
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
