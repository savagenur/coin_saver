import 'package:coin_saver/constants.dart';
import 'package:coin_saver/features/presentation/widgets/shadowed_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
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
                        indicatorColor: primaryColor,
                        
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: primaryColor),
                        unselectedLabelColor: primaryColor,
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
                          SfCircularChart(
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
                                yValueMapper: (GDPData data, index) =>
                                    data.amount,
                              )
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
                  padding: EdgeInsets.only(right: 10, bottom: 10, left: 10),
                  child: CategoryTile(),
                ),
              ),
              sizeVer(70),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.menu),
      ),
      title: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on),
                Text(
                  "Main",
                  style: TextStyle(fontSize: 16),
                ),
                Icon(
                  Icons.arrow_drop_down_sharp,
                ),
              ],
            ),
          ),
          Text(
            "\$31700",
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
        IconButton(onPressed: () {}, icon: const Icon(Icons.list_alt_rounded)),
      ],
    );
  }

  List<GDPData> getGDPData() {
    return [
      GDPData(category: "Trans", amount: 15),
      GDPData(category: "alc", amount: 300),
      GDPData(category: "fit", amount: 1000),
      GDPData(category: "food", amount: 100),
      GDPData(category: "enter", amount: 500),
      GDPData(category: "swim", amount: 250),
    ];
  }
}



class GDPData {
  final String category;
  final int amount;
  GDPData({
    required this.category,
    required this.amount,
  });
}
