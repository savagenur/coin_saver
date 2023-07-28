import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/presentation/pages/add_transaction/add_transaction_page.dart';
import 'package:coin_saver/features/presentation/pages/home/widgets/account_switch_pull_down_btn.dart';
import 'package:coin_saver/features/presentation/pages/home/widgets/period_tab_bar.dart';
import 'package:coin_saver/features/presentation/pages/transactions/widgets/custom_search_widget.dart';
import 'package:coin_saver/features/presentation/pages/transactions/widgets/list_date_transactions_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/period_enum.dart';
import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../bloc/account/account_bloc.dart';
import '../../bloc/cubit/period/period_cubit.dart';
import '../../bloc/cubit/selected_date/selected_date_cubit.dart';
import '../../bloc/cubit/transaction_period/transaction_period_cubit.dart';
import '../../bloc/home_time_period/home_time_period_bloc.dart';
import '../home/home_page.dart';
import '../main_transaction/main_transaction_page.dart';
import '../../widgets/day_navigation_widget.dart';
import '../../widgets/shadowed_container_widget.dart';

class TransactionsPage extends StatefulWidget {
  final AccountEntity account;
  final Period period;
  final bool isIncome;
  const TransactionsPage(
      {super.key,
      required this.account,
      required this.period,
      required this.isIncome});

  @override
  State<TransactionsPage> createState() => TransactionsPageState();
}

class TransactionsPageState extends State<TransactionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime _selectedDate;
  late DateTime _selectedDateEnd;
  late AccountEntity _account;
  late bool _isIncome;
  late double _totalExpense;
  late Period _selectedPeriod;
  late final int _initialIndexTab;

  Filter _selectedFilter = Filter.byDate;
  List<TransactionEntity> _filteredTransactions = [];
  List<TransactionEntity> _transactions = [];
  Map<DateTime, List<TransactionEntity>> _filteredTransactionsMap = {};
  @override
  void initState() {
    super.initState();
    _account = widget.account;
    _isIncome = widget.isIncome;
    _initialIndexTab = getKeyByValue(periodValues, widget.period)!;
    _tabController =
        TabController(length: 5, vsync: this, initialIndex: _initialIndexTab);
  }

  Map<DateTime, List<TransactionEntity>> _filterTransactions(
      List<TransactionEntity> transactions) {
    Map<DateTime, List<TransactionEntity>> map = {};
    for (var transaction in transactions) {
      DateTime transactionDate = transaction.date;
      if (map.containsKey(transactionDate)) {
        map[transactionDate]!.add(transaction);
      } else {
        map[transactionDate] = [transaction];
      }
    }
    return map;
  }

  String _searchQuery = '';
  bool _isSearching = false;
  void _searchTransactions(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTransactions = _transactions.where((transaction) {
        // Perform case-insensitive search based on the transaction name
        return transaction.category.name
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

  void isSearchingToFalse() {
    setState(() {
      _isSearching = false;
      _searchQuery = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    // Update the tab index to select the desired tab (e.g., index 1 for the second tab)
    return BlocBuilder<PeriodCubit, Period>(
      builder: (context, selectedPeriod) {
        return BlocBuilder<TransactionPeriodCubit, List<TransactionEntity>>(
          builder: (context, transactions) {
            return BlocBuilder<SelectedDateCubit, DateRange>(
              builder: (context, dateRange) {
                return BlocBuilder<AccountBloc, AccountState>(
                  builder: (context, accountState) {
                    if (accountState is AccountLoaded) {
                      return BlocBuilder<HomeTimePeriodBloc,
                          HomeTimePeriodState>(
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
                                    orElse: () => accountError);

                                // Total amountMoney of MainTransactions

                                var allTransactions = timePeriodState
                                    .transactions
                                    .where((transaction) =>
                                        transaction.isIncome == _isIncome)
                                    .toList()
                                  ..sort(
                                    (a, b) => _selectedFilter == Filter.byDate
                                        ? b.date.compareTo(a.date)
                                        : b.amount.compareTo(a.amount),
                                  );
                                _totalExpense = (_searchQuery != ''
                                        ? _filteredTransactions
                                        : allTransactions)
                                    .fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue + element.amount);
                                BlocProvider.of<TransactionPeriodCubit>(context)
                                    .setPeriod(
                                  period: selectedPeriod,
                                  selectedDate: _selectedDate,
                                  totalTransactions: allTransactions,
                                  selectedEnd: _selectedDateEnd,
                                );
                                _transactions = transactions;
                                _filteredTransactionsMap = _filterTransactions(
                                    _searchQuery != ""
                                        ? _filteredTransactions
                                        : _transactions);

                                return WillPopScope(
                                  onWillPop: () async {
                                    await Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        PageConst.homePage,
                                        arguments: HomePage(
                                          isIncome: _isIncome,
                                          period: _selectedPeriod,
                                        ),
                                        (route) =>
                                            route.settings.name ==
                                            PageConst.homePage);
                                    return false;
                                  },
                                  child: DefaultTabController(
                                    initialIndex: _isIncome ? 1 : 0,
                                    length: 2,
                                    child: Scaffold(
                                      appBar: _buildAppBar(
                                          _account, accountState.accounts),
                                      body: Column(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: ShadowedContainerWidget(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        PeriodTabBar(
                                                            tabController:
                                                                _tabController,
                                                            selectedPeriod:
                                                                _selectedPeriod,
                                                            selectedDate:
                                                                _selectedDate,
                                                            selectedDateEnd:
                                                                _selectedDateEnd,
                                                            transactions:
                                                                allTransactions),
                                                        DayNavigationWidget(
                                                          account: _account,
                                                          isIncome: true,
                                                          dateTime:
                                                              _selectedDate,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child:
                                                              _buildTotalFilter(
                                                                  context),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child:
                                                              ListDateTransactionsWidget(
                                                            filteredTransactionsMap:
                                                                _filteredTransactionsMap,
                                                            account: _account,
                                                            accounts:
                                                                accountState
                                                                    .accounts,
                                                            isSearchingToFalse:
                                                                isSearchingToFalse,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    sizeVer(10)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      floatingActionButtonLocation:
                                          FloatingActionButtonLocation
                                              .centerFloat,
                                      floatingActionButton:
                                          FloatingActionButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              PageConst.addTransactionPage,
                                              arguments: AddTransactionPage(
                                                isIncome: _isIncome,
                                                account: _account,
                                                selectedDate: _selectedDate,
                                                isTransactionsPage: true,
                                              ));
                                        },
                                        child:
                                            const Icon(FontAwesomeIcons.plus),
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
          },
        );
      },
    );
  }

  Row _buildTotalFilter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total: ${NumberFormat.currency(symbol: _account.currency.symbol).format(_totalExpense)}",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        PopupMenuButton(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    value: Filter.byDate,
                    onTap: () {},
                    child: const Text("By date")),
                PopupMenuItem(
                    value: Filter.byAmount,
                    onTap: () {},
                    child: const Text("By amount")),
              ];
            },
            child: Row(
              children: [
                Text(
                  _selectedFilter == Filter.byDate ? "By date" : "By amount",
                  style: const TextStyle(decoration: TextDecoration.underline),
                ),
                const Icon(Icons.arrow_drop_down)
              ],
            )),
      ],
    );
  }

  AppBar _buildAppBar(AccountEntity account, List<AccountEntity> accounts) {
    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchQuery = '';
            });
          },
        ),
        title: TextField(
          onChanged: _searchTransactions,
          autofocus: true,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintStyle: TextStyle(color: Colors.white),
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
      );
    } else {
      return AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                PageConst.homePage,
                arguments: HomePage(
                  isIncome: _isIncome,
                  period: _selectedPeriod,
                ),
                (route) => route.settings.name == PageConst.homePage),
            icon: const Icon(FontAwesomeIcons.arrowLeft)),
        title: AccountSwitchPullDownBtn(accounts: accounts, account: account),
        bottom: TabBar(
          onTap: (value) {
            switch (value) {
              case 0:
                setState(() {
                  _isIncome = false;
                });
                break;
              case 1:
                setState(() {
                  _isIncome = true;
                });
                break;
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
                setState(() {
                  _isSearching = true;
                });
              },
              icon: const Icon(FontAwesomeIcons.magnifyingGlass)),
        ],
      );
    }
  }
}
