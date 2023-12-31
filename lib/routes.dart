import 'package:coin_saver/features/presentation/pages/accounts_chapter/accounts/accounts_page.dart';
import 'package:coin_saver/features/presentation/pages/accounts_chapter/create_transfer/create_transfer_page.dart';
import 'package:coin_saver/features/presentation/pages/accounts_chapter/crud_account/crud_account_page.dart';
import 'package:coin_saver/features/presentation/pages/accounts_chapter/transfer_history/transfer_history_page.dart';
import 'package:coin_saver/features/presentation/pages/add_category/add_category_page.dart';
import 'package:coin_saver/features/presentation/pages/add_transaction/add_transaction_page.dart';
import 'package:coin_saver/features/presentation/pages/add_transaction/widget/calculator_page.dart';
import 'package:coin_saver/features/presentation/pages/catalog_icons/catalog_icons_page.dart';
import 'package:coin_saver/features/presentation/pages/categories_chapter/categories/categories_page.dart';
import 'package:coin_saver/features/presentation/pages/charts_chapter/charts/charts_page.dart';
import 'package:coin_saver/features/presentation/pages/colors/colors_page.dart';
import 'package:coin_saver/features/presentation/pages/home/home_page.dart';
import 'package:coin_saver/features/presentation/pages/main_transaction/main_transaction_page.dart';
import 'package:coin_saver/features/presentation/pages/reminders_chapter/create_reminder/create_reminder_page.dart';
import 'package:coin_saver/features/presentation/pages/reminders_chapter/reminders/reminders_page.dart';
import 'package:coin_saver/features/presentation/pages/settings_chapter/settings/settings_page.dart';
import 'package:coin_saver/features/presentation/pages/transaction_detail/transaction_detail_page.dart';
import 'package:coin_saver/features/presentation/pages/transactions/transactions_page.dart';
import 'package:coin_saver/features/presentation/pages/welcome_chapter/choose_default_currency/choose_default_currency_page.dart';
import 'package:coin_saver/features/presentation/widgets/select_currency_widget.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'constants/constants.dart';
import 'features/presentation/pages/accounts_chapter/transfer_detail/transfer_detail_page.dart';
import 'features/presentation/pages/create_category/create_category_page.dart';

class AppRoute {
  Route onGenerateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case PageConst.homePage:
        args = args as HomePage;
        return _routeBuilder(
            HomePage(
              isIncome: args.isIncome,
              period: args.period,
            ),
            PageConst.homePage);

      case PageConst.addTransactionPage:
        args = args as AddTransactionPage;

        return _routeBuilder(
            AddTransactionPage(
              isIncome: args.isIncome,
              account: args.account,
              selectedDate: args.selectedDate,
              transaction: args.transaction,
              category: args.category,
              isTransactionsPage: args.isTransactionsPage,
            ),
            PageConst.addTransactionPage);
      case PageConst.catalogIconsPage:
        return _routeBuilder(
            const CatalogIconsPage(), PageConst.catalogIconsPage);
      case PageConst.colorsPage:
        return _routeBuilder(const ColorsPage(), PageConst.colorsPage);
      case PageConst.createCategoryPage:
        args = args as CreateCategoryPage;
        return _routeBuilder(
            CreateCategoryPage(
              isIncome: args.isIncome,
              category: args.category,
              isUpdate: args.isUpdate,
            ),
            PageConst.createCategoryPage);
      case PageConst.transactionsPage:
        args = args as TransactionsPage;
        return _routeBuilder(
            TransactionsPage(
              account: args.account,
              period: args.period,
              isIncome: args.isIncome,
            ),
            PageConst.transactionsPage);
      case PageConst.mainTransactionPage:
        args = args as MainTransactionPage;

        return _routeBuilder(
            MainTransactionPage(
              mainTransaction: args.mainTransaction,
            ),
            PageConst.mainTransactionPage);
      case PageConst.selectCurrencyWidget:
        args = args as SelectCurrencyWidget;

        return _routeBuilder(
            SelectCurrencyWidget(
                currency: args.currency, setCurrency: args.setCurrency),
            PageConst.selectCurrencyWidget);
      case PageConst.transactionDetailPage:
        args = args as TransactionDetailPage;

        return _routeBuilder(
            TransactionDetailPage(
              transaction: args.transaction,
              account: args.account,
            ),
            PageConst.transactionDetailPage);
      case PageConst.addCategoryPage:
        args = args as AddCategoryPage;
        return _routeBuilder(
            AddCategoryPage(
              isIncome: args.isIncome,
            ),
            PageConst.addCategoryPage);
      case PageConst.accountsPage:
        return _routeBuilder(const AccountsPage(), PageConst.accountsPage);
      case PageConst.cRUDAccountPage:
        args = args as CRUDAccountPage;
        return _routeBuilder(
            CRUDAccountPage(
              mainCurrency: args.mainCurrency,
              account: args.account,
              isUpdatePage: args.isUpdatePage,
            ),
            PageConst.cRUDAccountPage);
      case PageConst.createTransferPage:
        args = args as CreateTransferPage;
        return _routeBuilder(
            CreateTransferPage(
              selectedDate: args.selectedDate,
              accountFrom: args.accountFrom,
              accountTo: args.accountTo,
              amountFrom: args.amountFrom,
              amountTo: args.amountTo,
              isUpdate: args.isUpdate,
              transfer: args.transfer,
            ),
            PageConst.createTransferPage);
      case PageConst.transferHistoryPage:
        return _routeBuilder(
            const TransferHistoryPage(), PageConst.transferHistoryPage);
      case PageConst.categoriesPage:
        return _routeBuilder(const CategoriesPage(), PageConst.categoriesPage);
      case PageConst.transferDetailPage:
        args = args as TransferDetailPage;
        return _routeBuilder(TransferDetailPage(transfer: args.transfer),
            PageConst.transferDetailPage);
      case PageConst.remindersPage:
        return _routeBuilder(const RemindersPage(), PageConst.remindersPage);
      case PageConst.createReminderPage:
        args = args as CreateReminderPage;

        return _routeBuilder(
            CreateReminderPage(
              reminder: args.reminder,
              isUpdate: args.isUpdate,
            ),
            PageConst.createReminderPage);
      case PageConst.chartsPage:
        return _routeBuilder(const ChartsPage(), PageConst.chartsPage);
      case PageConst.chooseDefaultCurrencyPage:
        return _routeBuilder(const ChooseDefaultCurrencyPage(),
            PageConst.chooseDefaultCurrencyPage);
      case PageConst.settingsPage:
        return _routeBuilder(const SettingsPage(), PageConst.settingsPage);
      case PageConst.calculatorPage:
        args = args as CalculatorPage;

        return PageTransition(
            child: CalculatorPage(
              setAmount: args.setAmount,
              currentValue: args.currentValue,
            ),
            type: PageTransitionType.rightToLeft);
      default:
        return _routeBuilder(const NotFoundPage(), "/notFountPage");
    }
  }

  PageTransition _routeBuilder(Widget child, String? routeName) {
    return PageTransition(
      type: PageTransitionType.fade,
      child: child,
      settings: RouteSettings(name: routeName),
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
