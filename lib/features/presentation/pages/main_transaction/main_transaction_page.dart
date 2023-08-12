import 'package:coin_saver/features/presentation/pages/transactions/widgets/list_date_transactions_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
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
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/period_enum.dart';
import '../../bloc/home_time_period/home_time_period_bloc.dart';

class MainTransactionPage extends StatefulWidget {
  final TransactionEntity mainTransaction;
  const MainTransactionPage({super.key, required this.mainTransaction});

  @override
  State<MainTransactionPage> createState() => _MainTransactionPageState();
}

class _MainTransactionPageState extends State<MainTransactionPage> {
  AccountEntity? _account;
  late TransactionEntity _mainTransaction;
  late Period _selectedPeriod;
  List<TransactionEntity> _mainTransactions = [];
  double _totalAmount = 0;
  List<TransactionEntity> _transactions = [];
  Map<DateTime, List<TransactionEntity>> _filteredMap = {};
  Filter _selectedFilter = Filter.byDate;

  @override
  void initState() {
    super.initState();
    _mainTransaction = widget.mainTransaction;
  }

  Map<DateTime, List<TransactionEntity>> _filterTransactions(
      List<TransactionEntity> transactions) {
    Map<DateTime, List<TransactionEntity>> map = {};
    for (var transaction in transactions) {
      DateTime transactionDate = DateTime(
          transaction.date.year, transaction.date.month, transaction.date.day);
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
                      return BlocBuilder<HomeTimePeriodBloc,
                          HomeTimePeriodState>(
                        builder: (context, timePeriodState) {
                          if (timePeriodState is HomeTimePeriodLoaded) {
                            _selectedPeriod = selectedPeriod;
                            _account = accountState.accounts.firstWhere(
                                (account) => account.isPrimary,
                                orElse: () => accountError);
                            _mainTransactions = transactions
                                .where((transaction) => _account!.id == "total"
                                    ? transaction.category ==
                                            _mainTransaction.category &&
                                        transaction.isIncome ==
                                            _mainTransaction.isIncome
                                    : transaction.accountId == _account!.id &&
                                        transaction.category ==
                                            _mainTransaction.category &&
                                        transaction.isIncome ==
                                            _mainTransaction.isIncome)
                                .toList();

                            // Total amountMoney of MainTransactions
                            _totalAmount = _mainTransactions.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.amount);

                            var allTransactions = _account!.transactionHistory
                                .where((transaction) =>
                                    transaction.category.id ==
                                    widget.mainTransaction.category.id)
                                .toList()
                              ..sort(
                                (a, b) => _selectedFilter == Filter.byDate
                                    ? b.date.compareTo(a.date)
                                    : b.amount.compareTo(a.amount),
                              );
                            BlocProvider.of<TransactionPeriodCubit>(context)
                                .setPeriod(
                              period: _selectedPeriod,
                              selectedDate: selectedDate,
                              totalTransactions: allTransactions,
                              selectedEnd: selectedEnd,
                            );
                            _transactions =
                                BlocProvider.of<TransactionPeriodCubit>(context)
                                    .state;
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
                                                _selectedFilter = value;
                                              });
                                            },
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                    value: Filter.byDate,
                                                    onTap: () {},
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .byDate)),
                                                PopupMenuItem(
                                                    value: Filter.byAmount,
                                                    onTap: () {},
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .byAmount)),
                                              ];
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  _selectedFilter ==
                                                          Filter.byDate
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .byDate
                                                      : AppLocalizations.of(
                                                              context)!
                                                          .byAmount,
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
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: ListDateTransactionsWidget(transactions: _transactions, accounts: 
                                            accountState. accounts, account: _account!, selectedFilter: _selectedFilter)),
                                      ],
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
                                        selectedDate: DateTime.now(),
                                        category:
                                            widget.mainTransaction.category,
                                      ));
                                },
                                child: const Icon(FontAwesomeIcons.plus),
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
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(FontAwesomeIcons.arrowLeft)),
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
    );
  }
}

enum Filter {
  byDate,
  byAmount,
}
