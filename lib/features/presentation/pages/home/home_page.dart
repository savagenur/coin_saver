import 'package:coin_saver/constants/period_enum.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/pages/add_transaction/add_transaction_page.dart';
import 'package:coin_saver/features/presentation/pages/home/widgets/account_switch_pull_down_btn.dart';
import 'package:coin_saver/features/presentation/pages/home/widgets/circular_chart.dart';
import 'package:coin_saver/features/presentation/pages/home/widgets/period_tab_bar.dart';
import 'package:coin_saver/features/presentation/pages/main_transaction/main_transaction_page.dart';
import 'package:coin_saver/features/presentation/pages/transactions/transactions_page.dart';
import 'package:coin_saver/features/presentation/widgets/day_navigation_widget.dart';
import 'package:coin_saver/features/presentation/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/presentation/widgets/shadowed_container_widget.dart';

import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../bloc/account/account_bloc.dart';
import '../../bloc/cubit/selected_date/selected_date_cubit.dart';
import '../../bloc/home_time_period/home_time_period_bloc.dart';
import '../../widgets/category_tile.dart';

class HomePage extends StatefulWidget {
  final bool isIncome;
  final Period period;
  const HomePage({
    super.key,
    this.isIncome = false,
    this.period = Period.day,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // late final TabController _tabController;
  late bool _isIncome;
  // Selected Period
  late Period _selectedPeriod;
  // Drawer key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // DateTime
  late DateTime _selectedDate;
  late DateTime _selectedDateEnd;
  late AccountEntity _account;
  late double _totalExpense;
  late final int _initialIndexTab;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initialIndexTab = getKeyByValue(periodValues, widget.period)!;
    _tabController =
        TabController(length: 5, vsync: this, initialIndex: _initialIndexTab);
    _isIncome = widget.isIncome;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedDateCubit, DateRange>(
      builder: (context, dateRange) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accountState) {
            if (accountState is AccountLoaded) {
              return BlocBuilder<HomeTimePeriodBloc, HomeTimePeriodState>(
                builder: (context, timePeriodState) {
                  if (timePeriodState is HomeTimePeriodLoaded) {
                    return BlocBuilder<PeriodCubit, Period>(
                      builder: (context, selectedPeriod) {
                        _selectedPeriod = selectedPeriod;
                        // Selected DateTime
                        _selectedDate = dateRange.startDate;
                        _selectedDateEnd = dateRange.endDate;
                        // Primary Account
                        _account = accountState.accounts.firstWhere(
                          (account) => account.isPrimary == true,
                          orElse: () => accountError,
                        );

                        // MainTransactions Sort
                        List<TransactionEntity> transactions = timePeriodState
                            .transactions
                            .where((transaction) =>
                                transaction.isIncome == _isIncome &&transaction.isTransfer==null )
                            .toList()
                          ..sort(
                            (a, b) => b.amount.compareTo(a.amount),
                          );
                        // Total amountMoney of MainTransactions
                        _totalExpense = transactions.fold(
                            0,
                            (previousValue, element) =>
                                previousValue + element.amount);
                        return WillPopScope(
                          onWillPop: () async {
                            SystemNavigator.pop();
                            return false;
                          },
                          child: DefaultTabController(
                            initialIndex: _isIncome ? 1 : 0,
                            length: 2,
                            child: Scaffold(
                              key: _scaffoldKey,
                              drawer: const MyDrawer(),
                              appBar:
                                  _buildAppBar(_account, accountState.accounts),
                              body: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ShadowedContainerWidget(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Column(
                                          children: [
                                            PeriodTabBar(
                                                tabController: _tabController,
                                                selectedPeriod: _selectedPeriod,
                                                selectedDate: _selectedDate,
                                                selectedDateEnd:
                                                    _selectedDateEnd,
                                                transactions: transactions),
                                            DayNavigationWidget(
                                              selectedPeriod: _selectedPeriod,
                                              account: _account,
                                              dateTime: _selectedDate,
                                              isIncome: _isIncome,
                                            ),
                                            CircularChartWidget(
                                                transactions: transactions,
                                                selectedDate: _selectedDate,
                                                tooltipBehavior:
                                                    TooltipBehavior(
                                                  animationDuration: 1,
                                                  enable: true,
                                                  textStyle: const TextStyle(
                                                      fontSize: 16),
                                                  format:
                                                      'point.x - ${_account.currency.symbol}point.y',
                                                ),
                                                account: _account,
                                                totalExpense: _totalExpense),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ...List.generate(
                                      transactions.length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, bottom: 10, left: 10),
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  PageConst.mainTransactionPage,
                                                  arguments:
                                                      MainTransactionPage(
                                                    mainTransaction:
                                                        transactions[index],
                                                  ));
                                            },
                                            child: CategoryTile(
                                              totalExpense: _totalExpense,
                                              mainTransaction:
                                                  transactions[index],
                                              account: _account,
                                            )),
                                      ),
                                    ),
                                    sizeVer(70),
                                  ],
                                ),
                              ),
                              floatingActionButton: FloatingActionButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, PageConst.addTransactionPage,
                                      arguments: AddTransactionPage(
                                        selectedDate: _selectedDate,
                                        isIncome: _isIncome,
                                        account: _account,
                                      ));
                                },
                                child: const Icon(FontAwesomeIcons.plus),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Scaffold();
                  }
                },
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        );
      },
    );
  }

  AppBar _buildAppBar(AccountEntity account, List<AccountEntity> accounts) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: const Icon(FontAwesomeIcons.bars),
      ),
      title: AccountSwitchPullDownBtn(accounts: accounts, account: account),
      bottom: TabBar(
        onTap: (value) {
          switch (value) {
            case 0:
              setState(() {
                _isIncome = false;
              });
              return;
            case 1:
              setState(() {
                _isIncome = true;
              });
              return;
            default:
          }
        },
        padding: const EdgeInsets.symmetric(horizontal: 20),
        indicatorPadding: const EdgeInsets.only(bottom: 5),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(
            child: Text("EXPENSES"),
          ),
          Tab(child: Text("INCOME")),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, PageConst.transactionsPage,
                  arguments: TransactionsPage(
                    account: account,
                    period: _selectedPeriod,
                    isIncome: _isIncome,
                  ));
            },
            icon: const Icon(FontAwesomeIcons.rectangleList)),
      ],
    );
  }
}
