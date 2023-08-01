import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/presentation/bloc/home_time_period/home_time_period_bloc.dart';
import 'package:coin_saver/features/presentation/widgets/shadowed_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../constants/chart_period_enum.dart';
import '../../../../../constants/period_enum.dart';
import '../../../../../constants/time_group_type_enum.dart';
import '../../../../data/models/time_group/time_group_model.dart';
import '../../../bloc/account/account_bloc.dart';
import '../../../widgets/my_drawer.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final TabController _tabController;
  late final TabController _defaultTabController;
  TimeGroupType _timeGroupType = TimeGroupType.month;
  List<AccountEntity> _accounts = [];
  AccountEntity? _account;
  List<TransactionEntity> _transactions = [];
  List<TimeGroupModel> _timeGroupModels = [];
  DateFormat _dateFormat = DateFormat.yMMM();
  DateTimeIntervalType _intervalType = DateTimeIntervalType.months;
  bool? _isIncome ;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _defaultTabController =
        TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      Navigator.popUntil(context, (route) => route.isFirst);
      return true;
    }, child: BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        if (accountState is AccountLoaded) {
          _accounts = accountState.accounts;
          _account = _accounts.firstWhere((element) => element.isPrimary);
          return BlocBuilder<HomeTimePeriodBloc, HomeTimePeriodState>(
            builder: (context, homeTimePeriodState) {
              if (homeTimePeriodState is HomeTimePeriodLoaded) {
                _transactions = _account!.transactionHistory;
                _timeGroupModels = _transactions.isEmpty
                    ? []
                    : groupTransactionsByTime(_transactions, _timeGroupType);
                return Scaffold(
                  key: _scaffoldKey,
                  appBar: _buildAppBar(),
                  drawer: const MyDrawer(),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ShadowedContainerWidget(
                          height: MediaQuery.of(context).size.height * .8,
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            children: [
                              TabBar(
                                controller: _tabController,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                indicatorColor: Theme.of(context).primaryColor,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                                unselectedLabelColor:
                                    Theme.of(context).primaryColor,
                                onTap: (value) {
                                  setState(() {
                                    _timeGroupType =
                                        chartTimeGroupTypeValues[value]!;
                                    print(_timeGroupType);
                                    _timeGroupModels = groupTransactionsByTime(
                                        _transactions, _timeGroupType);
                                    setDateTimeIntervalType();
                                  });
                                },
                                tabs: kChartPeriodTitles
                                    .map(
                                      (e) => Tab(
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              Expanded(
                                child: _transactions.isEmpty
                                    ? Container()
                                    : SfCartesianChart(
                                      tooltipBehavior:
                                                    TooltipBehavior(
                                                  animationDuration: 1,
                                                  enable: true,
                                                  textStyle: const TextStyle(
                                                      fontSize: 16),
                                                  format:
                                                      'point.x - ${_account!.currency.symbol}point.y',
                                                ),
                                        enableSideBySideSeriesPlacement: true,
                                        primaryXAxis: DateTimeAxis(
                                          intervalType: _intervalType,
                                          title: AxisTitle(
                                              ),
                                          dateFormat: _dateFormat,
                                          // Set the number of days between each interval (1 for daily)
                                        ),
                                        primaryYAxis: NumericAxis(
                                          opposedPosition: true,
                                          
                                        ),
                                        
                                        zoomPanBehavior: ZoomPanBehavior(
                                          enablePanning: true,
                                          enableSelectionZooming: true,
                                          enableDoubleTapZooming: true,
                                          enablePinching: true,
                                        ),
                                        legend: const Legend(
                                          isVisible: true,
                                        ),
                                        series: setSeries(),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Scaffold();
            },
          );
        }
        return const Scaffold();
      },
    ));
  }

  setSeries() {
    if (_isIncome == null) {
      return [
        ColumnSeries(
          spacing: 5,
            width: 1,
            dataSource: _timeGroupModels,
            xValueMapper: (TimeGroupModel timeGroupModel, index) {
              return timeGroupModel.start;
            },
            yValueMapper: (TimeGroupModel timeGroupModel, index) =>
                timeGroupModel.income,
            name: "income"),
        ColumnSeries(
          // spacing: 5,

            dataSource: _timeGroupModels,
            xValueMapper: (TimeGroupModel timeGroupModel, index) {
              return timeGroupModel.start;
            },
            width: 1,
            yValueMapper: (TimeGroupModel timeGroupModel, index) =>
                timeGroupModel.expense,
            name: "expenses"),
        ColumnSeries(
            width: 1,
            dataSource: _timeGroupModels,
            xValueMapper: (TimeGroupModel timeGroupModel, index) {
              return timeGroupModel.start;
            },
            yValueMapper: (TimeGroupModel timeGroupModel, index) =>
                timeGroupModel.profit,
            name: "profit"),
        ColumnSeries(
            width: 1,
            dataSource: _timeGroupModels,
            xValueMapper: (TimeGroupModel timeGroupModel, index) {
              return timeGroupModel.start;
            },
            yValueMapper: (TimeGroupModel timeGroupModel, index) =>
                timeGroupModel.loss,
            name: "loss"),
      ];
    } else if (_isIncome == true) {
      return [
        ColumnSeries(
            width: 1,
            dataSource: _timeGroupModels,
            xValueMapper: (TimeGroupModel timeGroupModel, index) {
              return timeGroupModel.start;
            },
            yValueMapper: (TimeGroupModel timeGroupModel, index) =>
                timeGroupModel.income,
            name: "income"),
      ];
    } else {
      return [
        ColumnSeries(
            dataSource: _timeGroupModels,
            xValueMapper: (TimeGroupModel timeGroupModel, index) {
              return timeGroupModel.start;
            },
            width: 1,
            yValueMapper: (TimeGroupModel timeGroupModel, index) =>
                timeGroupModel.expense,
            name: "expenses"),
      ];
    }
  }

  void setDateTimeIntervalType() {
    switch (_timeGroupType) {
      case TimeGroupType.day:
        _intervalType = DateTimeIntervalType.days;
        _dateFormat = DateFormat.MEd();
        break;

      case TimeGroupType.week:
        _intervalType = DateTimeIntervalType.auto;
        _dateFormat = DateFormat.MEd();
        break;

      case TimeGroupType.month:
        _intervalType = DateTimeIntervalType.months;
        _dateFormat = DateFormat.yMMM();
        break;

      case TimeGroupType.year:
        _intervalType = DateTimeIntervalType.years;
        _dateFormat = DateFormat.y();
        break;

      default:
        _intervalType = DateTimeIntervalType.months;
        _dateFormat = DateFormat.yMMM();
        break;
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(FontAwesomeIcons.bars)),
      centerTitle: true,
      title: const Text("Charts"),
      bottom: TabBar(
        controller: _defaultTabController,
        onTap: (value) {
          switch (value) {
            case 0:
              setState(() {
                _isIncome = null;
              });
              return;
            case 1:
              setState(() {
                _isIncome = false;
              });
              return;
            case 2:
              setState(() {
                _isIncome = true;
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

List<TimeGroupModel> groupTransactionsByTime(
    List<TransactionEntity> transactions, TimeGroupType groupType) {
  transactions.sort((a, b) => a.date.compareTo(b.date));

  Map<String, List<TransactionEntity>> transactionsByTime = {};

  for (var transaction in transactions) {
    String timeKey;

    if (groupType == TimeGroupType.month) {
      timeKey = '${transaction.date.year}-${transaction.date.month}';
    } else {
      // Calculate the start and end dates for the week
      DateTime weekStart = transaction.date
          .subtract(Duration(days: transaction.date.weekday - 1));
      DateTime weekEnd = weekStart.add(Duration(days: 6));

      timeKey = '${weekStart.year}-${weekStart.month}-${weekStart.day}';
    }

    if (!transactionsByTime.containsKey(timeKey)) {
      transactionsByTime[timeKey] = [];
    }

    transactionsByTime[timeKey]!.add(transaction);
  }

  List<TimeGroupModel> timeGroupModels = [];

  transactionsByTime.forEach((key, value) {
    List<TransactionEntity> sortedTransactions = value;

    // Calculate the start and end dates for the time group
    DateTime start;
    DateTime end;

    if (groupType == TimeGroupType.month) {
      List<int> dateParts = key.split('-').map(int.parse).toList();
      start = DateTime(dateParts[0], dateParts[1]);
      end =
          DateTime(dateParts[0], dateParts[1] + 1).subtract(Duration(days: 1));
    } else {
      List<int> dateParts = key.split('-').map(int.parse).toList();
      start = DateTime(dateParts[0], dateParts[1], dateParts[2]);
      end = start.add(Duration(days: 6));
    }

    // Calculate income, expense, profit, and loss
    double income = 0;
    double expense = 0;

    for (var transaction in sortedTransactions) {
      if (transaction.isIncome) {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }

    double profit = income - expense;
    double loss = expense - income;

    timeGroupModels.add(TimeGroupModel(
      start: start,
      end: end,
      transactions: sortedTransactions,
      income: income.abs(),
      expense: expense.abs(),
      profit: profit < 0 ? 0 : profit,
      loss: loss < 0 ? 0 : loss,
    ));
  });

  return timeGroupModels;
}
