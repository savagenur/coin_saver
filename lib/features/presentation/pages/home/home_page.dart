import 'package:coin_saver/features/data/models/currency/currency_model.dart';
import 'package:coin_saver/features/data/models/main_transaction/main_transaction_model.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/presentation/bloc/main_transaction/main_transaction_bloc.dart';
import 'package:coin_saver/features/presentation/transactions/transactions_page.dart';
import 'package:coin_saver/features/presentation/widgets/day_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/presentation/widgets/shadowed_container_widget.dart';

import '../../bloc/account/account_bloc.dart';
import '../../widgets/category_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final _tooltipBehavior;
  late final TabController _tabController;
  bool isIncome = false;

  // DateTime
  DateTime dateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tooltipBehavior = TooltipBehavior(
      animationDuration: 1,
      enable: true,
      textStyle: TextStyle(fontSize: 16),
      format: '\$point.y - point.x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        if (accountState is AccountLoaded) {
          AccountEntity account = accountState.accounts
              .firstWhere((account) => account.isPrimary == true);

          return BlocConsumer<MainTransactionBloc, MainTransactionState>(
            listener: (context, mainTransactionState) {
              if (mainTransactionState is MainTransactionLoaded) {}
            },
            builder: (context, mainTransactionState) {
              if (mainTransactionState is MainTransactionLoaded) {
                List<MainTransactionEntity> mainTransactions =
                    mainTransactionState.mainTransactions
                        .where(
                          (mainTransaction) =>
                              mainTransaction.dateTime.year == dateTime.year &&
                              mainTransaction.dateTime.month ==
                                  dateTime.month &&
                              mainTransaction.dateTime.day == dateTime.day &&
                              mainTransaction.accountId == account.id &&
                              mainTransaction.isIncome == isIncome,
                        )
                        .toList();
                double totalExpense = mainTransactions.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.totalAmount);
                return DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: _buildAppBar(account, accountState.accounts),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ShadowedContainerWidget(
                              borderRadius: BorderRadius.circular(30),
                              child: Column(
                                children: [
                                  TabBar(
                                    controller: _tabController,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 40),
                                    labelPadding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    indicatorColor:
                                        Theme.of(context).primaryColor,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                    unselectedLabelColor:
                                        Theme.of(context).primaryColor,
                                    tabs: kChartPeriodTitles
                                        .map(
                                          (e) => Tab(
                                            child: Text(
                                              e,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  DayNavigationWidget(
                                      account: account, dateTime: dateTime),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      mainTransactions.isEmpty
                                          ? _buildEmptySfCircularChart()
                                          : SfCircularChart(
                                              tooltipBehavior: _tooltipBehavior,
                                              series: [
                                                DoughnutSeries<
                                                    MainTransactionEntity,
                                                    String>(
                                                  explode: true,
                                                  strokeColor: Colors.white,
                                                  strokeWidth: 2,
                                                  innerRadius: "70",
                                                  opacity: 1,
                                                  dataSource: mainTransactions,
                                                  xValueMapper:
                                                      (MainTransactionEntity
                                                              data,
                                                          index) {
                                                    return data.name;
                                                  },
                                                  pointColorMapper:
                                                      (datum, index) {
                                                    return datum.color;
                                                  },
                                                  yValueMapper:
                                                      (MainTransactionEntity
                                                                  data,
                                                              index) =>
                                                          data.totalAmount,
                                                ),
                                              ],
                                            ),
                                      Text(
                                        "$totalExpense",
                                        style: TextStyle(fontSize: 22),
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
                                  right: 10, bottom: 10, left: 10),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, PageConst.mainTransactionPage);
                                  },
                                  child: CategoryTile(
                                    totalExpense: totalExpense,
                                    mainTransaction: mainTransactions[index],
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
                          context,
                          PageConst.addTransactionPage,
                        );
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
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
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  AppBar _buildAppBar(AccountEntity account, List<AccountEntity> accounts) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.menu),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: GestureDetector(
              onTapUp: (details) =>
                  _showPopupMenu(context, details.globalPosition, accounts),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_balance_wallet_outlined),
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
          ),
          Text(
            "\$${account.balance.round()}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      bottom: TabBar(
        onTap: (value) {
          switch (value) {
            case 0:
              setState(() {
                isIncome = false;
              });
              return;
            case 1:
              setState(() {
                isIncome = true;
              });
              return;
            default:
          }
        },
        padding: EdgeInsets.symmetric(horizontal: 20),
        indicatorPadding: EdgeInsets.only(bottom: 5),
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        tabs: [
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
                dateTime: dateTime)
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

  void _showPopupMenu(BuildContext context, Offset position,
      List<AccountEntity> accounts) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect positionPopup = RelativeRect.fromRect(
      Rect.fromPoints(position, position),
      Offset.zero & overlay.size,
    );
    bool _selectedItem =
        accounts.firstWhere((account) => account.isPrimary).isPrimary;
    await showMenu(
      context: context,
      position: positionPopup,
      initialValue: _selectedItem,
      items: [
        ...List.generate(
          accounts.length,
          (index) => PopupMenuItem(
            value: accounts[index].isPrimary,
            child: RadioListTile(
              value: accounts[index].isPrimary,
              groupValue: _selectedItem,
              onChanged: (value) {
                context.read<AccountBloc>().add(SelectAccount(
                    accountEntity: accounts[index], accounts: accounts));
                Navigator.pop(context);
              },
              title: Text(accounts[index].name),
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}
