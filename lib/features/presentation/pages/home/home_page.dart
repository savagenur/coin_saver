import 'package:auto_size_text/auto_size_text.dart';
import 'package:coin_saver/constants/period_enum.dart';
import 'package:coin_saver/features/data/models/account/account_model.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/pages/add_transaction/add_transaction_page.dart';
import 'package:coin_saver/features/presentation/pages/main_transaction/main_transaction_page.dart';
import 'package:coin_saver/features/presentation/transactions/transactions_page.dart';
import 'package:coin_saver/features/presentation/widgets/day_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/presentation/widgets/shadowed_container_widget.dart';

import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../bloc/account/account_bloc.dart';
import '../../bloc/cubit/selected_date/selected_date_cubit.dart';
import '../../bloc/time_period/time_period_bloc.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../widgets/category_tile.dart';

class HomePage extends StatefulWidget {
  final DateTime? dateTime;
  final bool? isIncome;

  const HomePage({super.key, this.dateTime, this.isIncome = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final _tooltipBehavior;
  late final TabController _tabController;
  late bool _isIncome;
  // Selected Period
  late Period _selectedPeriod;

  // DateTime
  late DateTime _dateTime;
  @override
  void initState() {
    _isIncome = widget.isIncome!;
    super.initState();
    // SetDayPeriod

    _tabController = TabController(length: 5, vsync: this);

    // SfCircularChart toolTip
    _tooltipBehavior = TooltipBehavior(
      animationDuration: 1,
      enable: true,
      textStyle: const TextStyle(fontSize: 16),
      format: '\$point.y - point.x',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedDateCubit, DateTime>(
      builder: (context, selectedDate) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accountState) {
            if (accountState is AccountLoaded) {
              return BlocBuilder<TimePeriodBloc, TimePeriodState>(
                builder: (context, mainTimePeriodState) {
                  if (mainTimePeriodState is TimePeriodLoaded) {
                   

                    return BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, mainTransactionState) {
                        if (mainTransactionState is TransactionLoaded) {
                          // Selected DateTime
                          _dateTime = selectedDate;
                          // Primary Account
                          AccountEntity account =
                              accountState.accounts.firstWhere(
                            (account) => account.isPrimary == true,
                          );

                          // MainTransactions Sort
                          List<TransactionEntity> mainTransactions =
                              mainTimePeriodState.transactions
                                  .where((mainTransaction) => account.id ==
                                          "total"
                                      ? mainTransaction.isIncome == _isIncome
                                      : mainTransaction.accountId ==
                                              account.id &&
                                          mainTransaction.isIncome == _isIncome)
                                  .toList()
                                ..sort(
                                  (a, b) => b.amount.compareTo(a.amount),
                                );
                          // Total amountMoney of MainTransactions
                          double totalExpense = mainTransactions.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.amount);
                          return BlocBuilder<PeriodCubit, Period>(
                            builder: (context, selectedPeriod) {
                              _selectedPeriod = selectedPeriod;
                              return DefaultTabController(
                                initialIndex: _isIncome ? 1 : 0,
                                length: 2,
                                child: Scaffold(
                                  appBar: _buildAppBar(
                                      account, accountState.accounts),
                                  body: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: ShadowedContainerWidget(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Column(
                                              children: [
                                                _buildTabBar(context),
                                                DayNavigationWidget(
                                                  selectedPeriod:
                                                      _selectedPeriod,
                                                  account: account,
                                                  transactions:
                                                      mainTransactionState
                                                          .transactions,
                                                  dateTime: _dateTime,
                                                  isIncome: _isIncome,
                                                ),
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    mainTransactions.isEmpty
                                                        ? _buildEmptySfCircularChart()
                                                        : SfCircularChart(
                                                            tooltipBehavior:
                                                                _tooltipBehavior,
                                                            series: [
                                                              DoughnutSeries<
                                                                  TransactionEntity,
                                                                  String>(
                                                                animationDelay:
                                                                    1,
                                                                animationDuration:
                                                                    1,
                                                                explode: true,
                                                                strokeColor:
                                                                    Colors
                                                                        .white,
                                                                strokeWidth: 2,
                                                                innerRadius:
                                                                    "70",
                                                                opacity: 1,
                                                                dataSource:
                                                                    mainTransactions,
                                                                xValueMapper:
                                                                    (TransactionEntity
                                                                            data,
                                                                        index) {
                                                                  return data
                                                                      .category
                                                                      .name;
                                                                },
                                                                pointColorMapper:
                                                                    (datum,
                                                                        index) {
                                                                  return datum
                                                                      .color;
                                                                },
                                                                yValueMapper: (TransactionEntity
                                                                            data,
                                                                        index) =>
                                                                    data.amount,
                                                              ),
                                                            ],
                                                          ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .35,
                                                      child: AutoSizeText(
                                                        NumberFormat.currency(
                                                                symbol: account
                                                                    .currency
                                                                    .symbol)
                                                            .format(
                                                                totalExpense),
                                                        textAlign:
                                                            TextAlign.center,
                                                        minFontSize: 18,
                                                        maxFontSize: 25,
                                                        style: TextStyle(
                                                            fontSize: 24),
                                                        maxLines: 1,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ...List.generate(
                                          mainTransactions.length,
                                          (index) => Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10,
                                                bottom: 10,
                                                left: 10),
                                            child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      PageConst
                                                          .mainTransactionPage,
                                                      arguments:
                                                          MainTransactionPage(
                                                        mainTransaction:
                                                            mainTransactions[
                                                                index],
                                                      ));
                                                },
                                                child: CategoryTile(
                                                  totalExpense: totalExpense,
                                                  mainTransaction:
                                                      mainTransactions[index],
                                                  account: account,
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
                                            selectedDate: selectedDate,
                                            isIncome: _isIncome,
                                            account: account,
                                          ));
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
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

  TabBar _buildTabBar(BuildContext context) {
    return TabBar(
      controller: _tabController,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
      indicatorColor: Theme.of(context).primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      unselectedLabelColor: Theme.of(context).primaryColor,
      onTap: (value) {
        setState(() {
          _selectedPeriod = periodValues[value]!;
        });
        switch (_selectedPeriod) {
          case Period.day:
            context
                .read<TimePeriodBloc>()
                .add(SetDayPeriod(selectedDate: _dateTime));
            context.read<PeriodCubit>().changePeriod(_selectedPeriod);
            break;
          case Period.week:
            context
                .read<TimePeriodBloc>()
                .add(SetWeekPeriod(selectedDate: _dateTime));
            context.read<PeriodCubit>().changePeriod(_selectedPeriod);

            break;
          case Period.month:
            context
                .read<TimePeriodBloc>()
                .add(SetMonthPeriod(selectedDate: _dateTime));
            context.read<PeriodCubit>().changePeriod(_selectedPeriod);

            break;
          case Period.year:
            context
                .read<TimePeriodBloc>()
                .add(SetYearPeriod(selectedDate: _dateTime));
            context.read<PeriodCubit>().changePeriod(_selectedPeriod);

            break;
          case Period.period:
            context
                .read<TimePeriodBloc>()
                .add(SetYearPeriod(selectedDate: _dateTime));
            context.read<PeriodCubit>().changePeriod(_selectedPeriod);

            break;
          default:
            0;
        }
      },
      tabs: kChartPeriodTitles
          .map(
            (e) => Tab(
              child: Text(
                e,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          )
          .toList(),
    );
  }

  AppBar _buildAppBar(AccountEntity account, List<AccountEntity> accounts) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.menu),
      ),
      title: PullDownButton(
        itemBuilder: (context) {
          return [
            ...List.generate(
              accounts.length,
              (index) => PullDownMenuItem.selectable(
                onTap: () {
                  context
                      .read<AccountBloc>()
                      .add(SetPrimaryAccount(accountId: accounts[index].id));
                },
                selected: accounts[index].isPrimary,
                title: accounts[index].name,
                subtitle: NumberFormat.currency(
                        symbol: accounts[index].currency.symbol)
                    .format(accounts[index].balance),
                icon: accounts[index].iconData,
              ),
            ),
          ];
        },
        buttonBuilder: (context, showMenu) {
          return GestureDetector(
            onTap: showMenu,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(account.iconData),
                      sizeHor(5),
                      Text(
                        account.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                      const Icon(
                        Icons.arrow_drop_down_sharp,
                      ),
                    ],
                  ),
                ),
                Text(
                  NumberFormat.currency(symbol: account.currency.symbol)
                      .format(account.balance),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: account.balance.round() > 0
                          ? Colors.white
                          : Colors.red.shade300),
                ),
              ],
            ),
          );
        },
      ),
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        indicatorPadding: EdgeInsets.only(bottom: 5),
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
                  arguments: TransactionsPage(account: account));
            },
            icon: const Icon(Icons.list_alt_rounded)),
      ],
    );
  }

  SfCircularChart _buildEmptySfCircularChart() {
    return SfCircularChart(
      series: [
        DoughnutSeries<MainTransactionEntity, String>(
          animationDuration: 0,
          strokeColor: Colors.white,
          strokeWidth: 2,
          innerRadius: "70",
          opacity: 1,
          dataSource: [
            MainTransactionEntity(
                id: "id",
                accountId: "accountId",
                name: "name",
                iconData: Icons.data_array,
                color: Colors.grey,
                isIncome: false,
                totalAmount: 1,
                dateTime: _dateTime)
          ],
          xValueMapper: (MainTransactionEntity data, index) {
            return data.name;
          },
          pointColorMapper: (datum, index) {
            return Colors.grey;
          },
          yValueMapper: (MainTransactionEntity data, index) => 1,
        )
      ],
    );
  }
}
