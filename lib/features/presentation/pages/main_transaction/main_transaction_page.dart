import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/transaction_period/transaction_period_cubit.dart';
import 'package:coin_saver/features/presentation/pages/add_transaction/add_transaction_page.dart';
import 'package:coin_saver/features/presentation/pages/transaction_detail/transaction_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/period_enum.dart';
import '../../bloc/time_period/time_period_bloc.dart';

class MainTransactionPage extends StatefulWidget {
  final TransactionEntity mainTransaction;
  const MainTransactionPage({super.key, required this.mainTransaction});

  @override
  State<MainTransactionPage> createState() => _MainTransactionPageState();
}

class _MainTransactionPageState extends State<MainTransactionPage> {
  AccountEntity? _account;
  late TransactionEntity _mainTransaction;
  List<TransactionEntity> _mainTransactions = [];
  double _totalAmount = 0;
  List<TransactionEntity> _transactions = [];
  Map<DateTime, List<TransactionEntity>> _filteredMap = {};
  Filter selectedFilter = Filter.byDate;

  @override
  void initState() {
    super.initState();
    _mainTransaction = widget.mainTransaction;
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        if (accountState is AccountLoaded) {
          return BlocBuilder<SelectedDateCubit, DateRange>(
            builder: (context, dateRange) {
              var selectedDate = dateRange.startDate;
              var selectedEnd = dateRange.endDate;
              return BlocBuilder<TransactionPeriodCubit,
                  List<TransactionEntity>>(
                builder: (context, transactions) {
                  return BlocBuilder<PeriodCubit, Period>(
                    builder: (context, selectedPeriod) {
                      return BlocBuilder<TimePeriodBloc, TimePeriodState>(
                        builder: (context, timePeriodState) {
                          if (timePeriodState is TimePeriodLoaded) {
                            _account = accountState.accounts.firstWhere(
                              (account) => account.isPrimary,
                            );
                            _mainTransactions = timePeriodState.transactions
                                .where((mainTransaction) =>
                                    _account!.id == "total"
                                        ? mainTransaction.category ==
                                                _mainTransaction.category &&
                                            mainTransaction.isIncome ==
                                                _mainTransaction.isIncome
                                        : mainTransaction.accountId ==
                                                _account!.id &&
                                            mainTransaction.category ==
                                                _mainTransaction.category &&
                                            mainTransaction.isIncome ==
                                                _mainTransaction.isIncome)
                                .toList();

                            // Total amountMoney of MainTransactions
                            _totalAmount = _mainTransactions.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.amount);

                            var allTransactions = _account!.transactionHistory
                                .where((transaction) =>
                                    transaction.category ==
                                    widget.mainTransaction.category)
                                .toList()
                              ..sort(
                                (a, b) => selectedFilter == Filter.byDate
                                    ? b.date.compareTo(a.date)
                                    : b.amount.compareTo(a.amount),
                              );
                            BlocProvider.of<TransactionPeriodCubit>(context)
                                .setPeriod(
                                    period: selectedPeriod,
                                    selectedDate: selectedDate,
                                    totalTransactions: allTransactions,
                                    selectedEnd:selectedEnd,);
                            _transactions = transactions;
                            _filteredMap = _filterTransactions(_transactions);

                            return Scaffold(
                              appBar: _buildAppBar(),
                              body: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildPullDownButton(
                                            _account!, accountState.accounts),
                                        PopupMenuButton(
                                            onSelected: (value) {
                                              setState(() {
                                                selectedFilter = value;
                                              });
                                            },
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                    value: Filter.byDate,
                                                    onTap: () {},
                                                    child:
                                                        const Text("By date")),
                                                PopupMenuItem(
                                                    value: Filter.byAmount,
                                                    onTap: () {},
                                                    child: const Text(
                                                        "By amount")),
                                              ];
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  selectedFilter ==
                                                          Filter.byDate
                                                      ? "By date"
                                                      : "By amount",
                                                  style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                                const Icon(
                                                    Icons.arrow_drop_down)
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: _buildListTiles(
                                            accountState, context),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              floatingActionButtonLocation:
                                  FloatingActionButtonLocation.centerFloat,
                              floatingActionButton: FloatingActionButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, PageConst.addTransactionPage,
                                      arguments: AddTransactionPage(
                                          isIncome: _mainTransaction.isIncome,
                                          account: _account!,
                                          selectedDate: DateTime.now()));
                                },
                                child: const Icon(Icons.add),
                              ),
                            );
                          }
                          return const Scaffold();
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        }
        return const Scaffold();
      },
    );
  }

  Column _buildListTiles(AccountLoaded accountState, BuildContext context) {
    return Column(
      children: [
        ...List.generate(
          _filteredMap.keys.length,
          (keyIndex) {
            DateTime dateTime = _filteredMap.keys.elementAt(keyIndex);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMEd().format(dateTime),
                  style: const TextStyle(
                    color: secondaryColor,
                  ),
                ),
                ...List.generate(_filteredMap.values.elementAt(keyIndex).length,
                    (valueIndex) {
                  var transaction = _filteredMap[
                      _filteredMap.keys.elementAt(keyIndex)]![valueIndex];
                  String accountName = accountState.accounts
                      .firstWhere(
                          (element) => element.id == transaction.accountId)
                      .name;

                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                          context, PageConst.transactionDetailPage,
                          arguments: TransactionDetailPage(
                            transaction: transaction,
                            account: accountState.accounts.firstWhere(
                                (element) =>
                                    element.id == transaction.accountId),
                          ));
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: _mainTransaction.color,
                      child: Icon(
                        _mainTransaction.iconData,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(_mainTransaction.category.name),
                    subtitle:
                        _account!.id == "total" ? Text(accountName) : null,
                    trailing: Text(
                      NumberFormat.currency(symbol: _account!.currency.symbol)
                          .format(transaction.amount),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }),
                sizeVer(10)
              ],
            );
          },
        ),
        sizeVer(20),
      ],
    );
  }

  PullDownButton _buildPullDownButton(
      AccountEntity account, List<AccountEntity> accounts) {
    return PullDownButton(
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
              subtitle:
                  NumberFormat.currency(symbol: accounts[index].currency.symbol)
                      .format(accounts[index].balance),
              icon: accounts[index].iconData,
            ),
          ),
        ];
      },
      buttonBuilder: (context, showMenu) {
        return GestureDetector(
          onTap: showMenu,
          child: Row(
            children: [
              Icon(
                _account!.iconData,
                color: Theme.of(context).primaryColor,
              ),
              sizeHor(5),
              Text(
                _account!.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_drop_down_outlined)
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 70,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _mainTransaction.category.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              NumberFormat.currency(symbol: _account!.currency.symbol)
                  .format(_totalAmount),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      ],
    );
  }
}

enum Filter {
  byDate,
  byAmount,
}
