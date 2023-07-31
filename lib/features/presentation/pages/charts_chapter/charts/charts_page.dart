import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../widgets/my_drawer.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.popUntil(context, (route) => route.isFirst);
          return true;
        },
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: _buildAppBar(),
            drawer: const MyDrawer(),
            body: Column(
              children: [
                
              ],
            ),
          ),
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
          leading: IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(FontAwesomeIcons.bars)),
          centerTitle: true,
          title: const Text("Charts"),
          bottom: TabBar(
            
        onTap: (value) {
          switch (value) {
            case 0:
              setState(() {
                // _isIncome = null;
              });
              return;
            case 1:
              setState(() {
                // _isIncome = false;
              });
              return;
            case 2:
              setState(() {
                // _isIncome = true;
              });
              return;
            default:
          }
        },
        padding: const EdgeInsets.symmetric(horizontal: 20),
        indicatorPadding: const EdgeInsets.only(bottom: 5),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(
            child: Text("GENERAL"),
          ),
          Tab(
            child: Text("EXPENSES"),
          ),
          Tab(child: Text("INCOME")),
        ],
      ),
        );
  }
}
