import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/home_time_period/home_time_period_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/main_transaction/main_transaction_bloc.dart';
import 'package:coin_saver/features/presentation/pages/home/widgets/period_tab_bar.dart';
import 'package:coin_saver/features/presentation/widgets/day_navigation_widget.dart';
import 'package:coin_saver/features/presentation/widgets/shadowed_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../../constants/period_enum.dart';
import '../../../bloc/account/account_bloc.dart';
import '../create_transfer/create_transfer_page.dart';

class TransferHistoryPage extends StatefulWidget {
  const TransferHistoryPage({super.key});

  @override
  State<TransferHistoryPage> createState() => _TransferHistoryPageState();
}

class _TransferHistoryPageState extends State<TransferHistoryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  AccountEntity? _account;
  List<AccountEntity>? _accounts;
  DateTime? _selectedDate;
  DateTime? _selectedDateEnd;
  Period? _selectedPeriod;
  List<TransactionEntity>? _transfers;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    context.read<PeriodCubit>().changePeriod(Period.day);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeriodCubit, Period>(
      builder: (context, period) {
        _selectedPeriod = period;
        return BlocBuilder<SelectedDateCubit, DateRange>(
          builder: (context, dateRange) {
            return BlocBuilder<AccountBloc, AccountState>(
              builder: (context, accountState) {
                if (accountState is AccountLoaded) {
                  _selectedDate = dateRange.startDate;
                  _selectedDateEnd = dateRange.endDate;
                  _account = accountState.accounts
                      .firstWhere((element) => element.isPrimary);
                  _accounts = accountState.accounts;

                  return BlocBuilder<HomeTimePeriodBloc, HomeTimePeriodState>(
                    builder: (context, timePeriodState) {
                      if (timePeriodState is HomeTimePeriodLoaded) {
                        _transfers = timePeriodState.transactions
                            .where((transaction) => transaction.isTransfer!)
                            .toList()
                          ..sort(
                            (a, b) => b.amount.compareTo(a.amount),
                          );
                        return Scaffold(
                          appBar: _buildAppBar(context),
                          body: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ShadowedContainerWidget(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Column(
                                      children: [
                                        PeriodTabBar(
                                            tabController: _tabController,
                                            selectedPeriod: _selectedPeriod!,
                                            selectedDate: _selectedDate!,
                                            selectedDateEnd: _selectedDateEnd!,
                                            transactions: _transfers!),
                                        DayNavigationWidget(
                                            account: _account!,
                                            dateTime: _selectedDate!,
                                            isIncome: false),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children:
                                                  _transfers!.map((transfer) {
                                                final accountFrom = _accounts!
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        transfer.accountFromId);
                                                final accountTo = _accounts!
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        transfer.accountToId);
                                                return ListTile(
                                                  onTap: () {
                                                    
                                                  },
                                                  minLeadingWidth: 20,
                                                  leading: const Icon(
                                                      FontAwesomeIcons
                                                          .arrowDown),
                                                  title: Text(accountFrom.name),
                                                  subtitle:
                                                      Text(accountTo.name),
                                                  trailing: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(NumberFormat.currency(
                                                              symbol:
                                                                  accountFrom
                                                                      .currency
                                                                      .symbol)
                                                          .format(transfer
                                                              .amountFrom!)),
                                                      sizeVer(5),
                                                      Text(NumberFormat.currency(
                                                              symbol: accountTo
                                                                  .currency
                                                                  .symbol)
                                                          .format(transfer
                                                              .amountTo!)),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.centerFloat,
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, PageConst.createTransferPage,
                                  arguments: CreateTransferPage(
                                    selectedDate: _selectedDate,
                                  ));
                            },
                            child: const Icon(FontAwesomeIcons.plus),
                          ),
                        );
                      }
                      return const Scaffold();
                    },
                  );
                }
                return const Scaffold();
              },
            );
          },
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const FaIcon(FontAwesomeIcons.arrowLeft),
      ),
      title: const Text("Transfers"),
      actions: [
        PullDownButton(
          itemBuilder: (context) {
            return _accounts!
                .map(
                  (account) => PullDownMenuItem.selectable(
                    onTap: () {
                      context
                          .read<AccountBloc>()
                          .add(SetPrimaryAccount(accountId: account.id));
                    },
                    selected: account.isPrimary,
                    title: account.name,
                    icon: account.iconData,
                    iconColor: Theme.of(context).primaryColor,
                  ),
                )
                .toList();
          },
          buttonBuilder: (context, showMenu) {
            return IconButton(
                onPressed: showMenu,
                icon: const Icon(FontAwesomeIcons.addressCard));
          },
        )
      ],
    );
  }
}
