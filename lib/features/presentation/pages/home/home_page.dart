import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/data/models/account/account_model.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/usecases/account/select_account_usecase.dart';
import 'package:coin_saver/features/presentation/widgets/shadowed_container_widget.dart';
import 'package:coin_saver/injection_container.dart' as di;

import '../../bloc/account/account_bloc.dart';
import '../../widgets/category_tile.dart';
import '../../widgets/day_navigation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final _chartData;
  late final _tooltipBehavior;
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _chartData = getGDPData();
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
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              labelPadding: EdgeInsets.symmetric(horizontal: 5),
                              indicatorColor: Theme.of(context).primaryColor,
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
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            DayNavigationWidget(),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                               account.balance==0?SfCircularChart(
                                series: [
                                  DoughnutSeries<GDPData, String>(
                                      strokeColor: Colors.white,
                                      strokeWidth: 2,
                                      innerRadius: "70",
                                      opacity: 1,
                                      dataSource: _chartData,
                                      xValueMapper: (GDPData data, index) {
                                        return "Nothing";
                                      },
                                      pointColorMapper: (datum, index) {
                                        return Colors.grey;
                                      },
                                      yValueMapper: (GDPData data, index) =>
                                          1,
                                    )
                                ],
                               ): SfCircularChart(
                                  tooltipBehavior: _tooltipBehavior,
                                  series: [
                                    DoughnutSeries<GDPData, String>(
                                      explode: true,
                                      strokeColor: Colors.white,
                                      strokeWidth: 2,
                                      innerRadius: "70",
                                      opacity: 1,
                                      dataSource: _chartData,
                                      xValueMapper: (GDPData data, index) {
                                        return data.category;
                                      },
                                      pointColorMapper: (datum, index) {
                                        return datum.color;
                                      },
                                      yValueMapper: (GDPData data, index) =>
                                          data.amount,
                                    ),
                                  ],
                                ),
                                Text(
                                  "\$100",
                                  style: TextStyle(fontSize: 22),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...List.generate(
                      5,
                      (index) => Padding(
                        padding:
                            EdgeInsets.only(right: 10, bottom: 10, left: 10),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PageConst.mainTransactionPage);
                            },
                            child: CategoryTile()),
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
                child: Icon(Icons.add),
              ),
            ),
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
        onTap: (value) {},
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
              Navigator.pushNamed(context, PageConst.transactionsPage);
            },
            icon: const Icon(Icons.list_alt_rounded)),
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

    final selectedOption = await showMenu(
      context: context,
      position: positionPopup,
      items: [
        ...List.generate(
          accounts.length,
          (index) => PopupMenuItem(
            child: Text(accounts[index].name),
            onTap: () async {
              context.read<AccountBloc>().add(SelectAccount(
                  accountEntity: accounts[index], accounts: accounts));
            },
          ),
        ),
      ],
      elevation: 8.0,
    );

    if (selectedOption != null) {
      // Handle the selected option here
      switch (selectedOption) {
        case 1:
          // Do something for Option 1
          break;
        case 2:
          // Do something for Option 2
          break;
        case 3:
          // Do something for Option 3
          break;
      }
    }
  }

  List<GDPData> getGDPData() {
    return [
      GDPData(category: "Trans", color: Colors.black, amount: 15),
      GDPData(category: "alc", color: Colors.red, amount: 300),
      GDPData(category: "fit", color: Colors.green, amount: 1000),
      GDPData(category: "food", color: Colors.blue, amount: 100),
      GDPData(category: "enter", color: Colors.pink, amount: 500),
      GDPData(category: "swim", color: Colors.orange, amount: 250),
    ];
  }
}

class GDPData {
  final String category;
  final int amount;
  final Color color;
  GDPData({
    required this.category,
    required this.amount,
    required this.color,
  });
}
