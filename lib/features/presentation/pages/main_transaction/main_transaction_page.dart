import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/time_period/time_period_cubit.dart';
import 'package:coin_saver/features/presentation/pages/add_transaction/add_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/period_enum.dart';

class MainTransactionPage extends StatefulWidget {
  final MainTransactionEntity mainTransaction;
  const MainTransactionPage({super.key, required this.mainTransaction});

  @override
  State<MainTransactionPage> createState() => _MainTransactionPageState();
}

class _MainTransactionPageState extends State<MainTransactionPage> {
  AccountEntity? _account;
  late final MainTransactionEntity _mainTransaction;
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
    return BlocBuilder<SelectedDateCubit, DateTime>(
      builder: (context, selectedDate) {
        return BlocBuilder<TimePeriodCubit, List<TransactionEntity>>(
          builder: (context, transactions) {
            return BlocBuilder<PeriodCubit, Period>(
              builder: (context, selectedPeriod) {
                return BlocBuilder<AccountBloc, AccountState>(
                  builder: (context, accountState) {
                    if (accountState is AccountLoaded) {
                      _account = accountState.accounts.firstWhere(
                        (account) => account.isPrimary,
                      );
                      var allTransactions = _account!.transactionHistory
                          .where((transaction) =>
                              transaction.category ==
                              widget.mainTransaction.name)
                          .toList()
                        ..sort(
                          (a, b) => selectedFilter == Filter.byDate
                              ? b.date.compareTo(a.date)
                              : b.amount.compareTo(a.amount),
                        );
                      BlocProvider.of<TimePeriodCubit>(context).setPeriod(
                          period: selectedPeriod,
                          selectedDate: selectedDate,
                          totalTransactions: allTransactions);
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
                                            selectedFilter == Filter.byDate
                                                ? "By date"
                                                : "By amount",
                                            style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                          const Icon(Icons.arrow_drop_down)
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      ...List.generate(
                                        _filteredMap.keys.length,
                                        (keyIndex) {
                                          DateTime dateTime = _filteredMap.keys
                                              .elementAt(keyIndex);
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                DateFormat.yMMMEd()
                                                    .format(dateTime),
                                                style: const TextStyle(
                                                  color: secondaryColor,
                                                ),
                                              ),
                                              ...List.generate(
                                                  _filteredMap.values
                                                      .elementAt(keyIndex)
                                                      .length, (valueIndex) {
                                                var transaction = _filteredMap[
                                                    _filteredMap.keys.elementAt(
                                                        keyIndex)]![valueIndex];

                                                return ListTile(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context,
                                                        PageConst
                                                            .transactionDetailPage);
                                                  },
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  leading: CircleAvatar(
                                                    backgroundColor:
                                                        _mainTransaction.color,
                                                    child: Icon(
                                                      _mainTransaction.iconData,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  title: Text(
                                                      _mainTransaction.name),
                                                  trailing: Text(
                                                    "${transaction.amount}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
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
                                  ),
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
              subtitle: "\$${accounts[index].balance}",
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
            _mainTransaction.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              "${_mainTransaction.totalAmount}",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
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
