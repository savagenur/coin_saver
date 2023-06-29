import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../widgets/day_navigation_widget.dart';
import '../widgets/shadowed_container_widget.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => TransactionsPageState();
}

class TransactionsPageState extends State<TransactionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ShadowedContainerWidget(
                  borderRadius: BorderRadius.circular(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
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
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total: c500",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                PopupMenuButton(
                                  child: Row(
                                    children: [
                                      Text(
                                        "By date",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      Icon(Icons.arrow_drop_down)
                                    ],
                                  ),
                                  initialValue: const PopupMenuItem(
                                      child: Text("By date")),
                                  itemBuilder: (context) {
                                    return [
                                      const PopupMenuItem(
                                          child: Text("By date")),
                                      const PopupMenuItem(
                                          child: Text("By amount")),
                                    ];
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                ...List.generate(
                                  20,
                                  (index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "June 28, 2023",
                                        style: TextStyle(
                                          color: secondaryColor,
                                        ),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              PageConst.transactionDetailPage);
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          child: Icon(Icons.bathtub_sharp),
                                        ),
                                        title: Text("Groceries"),
                                        trailing: Text(
                                          "c500000",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          child: Icon(Icons.bathtub_sharp),
                                        ),
                                        title: Text("Groceries"),
                                        trailing: Text(
                                          "c500000",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          child: Icon(Icons.bathtub_sharp),
                                        ),
                                        title: Text("Groceries"),
                                        trailing: Text(
                                          "c500000",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      sizeVer(10)
                                    ],
                                  ),
                                ),
                                sizeVer(20),
                              ],
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, PageConst.addTransactionPage);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Transactions",
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on),
                Text(
                  "Main",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white),
                ),
                Icon(
                  Icons.arrow_drop_down_sharp,
                ),
              ],
            ),
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
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      ],
    );
  }
}
