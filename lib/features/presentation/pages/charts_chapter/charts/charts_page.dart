import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/presentation/bloc/home_time_period/home_time_period_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

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
  late NumberFormat _currencyFormat;
  bool? _isIncome;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _defaultTabController =
        TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _defaultTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chartPeriodTitles = kGetChartPeriodTitles(context);

    return WillPopScope(onWillPop: () async {
      Navigator.popUntil(context, (route) => route.settings.name==PageConst.homePage);
      return true;
    }, child: BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        if (accountState is AccountLoaded) {
          _accounts = accountState.accounts;
          _account = _accounts.firstWhere((element) => element.isPrimary);
          _currencyFormat =
              NumberFormat.compactCurrency(symbol: _account!.currency.symbol);
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
                      TabBar(
                        controller: _tabController,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                        unselectedLabelColor: Theme.of(context).primaryColor,
                        onTap: (value) {
                          setState(() {
                            _timeGroupType = chartTimeGroupTypeValues[value]!;
                            print(_timeGroupType);
                            _timeGroupModels = groupTransactionsByTime(
                                _transactions, _timeGroupType);
                            setDateTimeIntervalType();
                          });
                        },
                        tabs: chartPeriodTitles
                            .map(
                              (e) => Tab(
                                child: Text(
                                  e,
                                  style:  TextStyle(color:Theme.of(context).primaryColor ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      _transactions.isEmpty
                          ? Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .thereIsNoTransactionYet,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(fontStyle: FontStyle.italic),
                                  ),
                                  const Icon(
                                    FontAwesomeIcons.folderOpen,
                                    size: 100,
                                    color: secondaryColor,
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      clipBehavior: Clip.none,
                                      scrollDirection: Axis.horizontal,
                                      reverse: true,
                                      child: _buildBarChart(context),
                                    ),
                                  ),
                                  _buildLegends()
                                ],
                              ),
                            ),
                      sizeVer(50)
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

  Row _buildLegends() {
    List<String> titles = [
      AppLocalizations.of(context)!.expense,
      AppLocalizations.of(context)!.income,
      AppLocalizations.of(context)!.loss,
      AppLocalizations.of(context)!.profit,
    ];
    List<Color> colors = [
      Colors.orange,
      Colors.blue,
      Colors.red,
      Colors.green,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          titles.length,
          (index) => Row(
                children: [
                  Icon(
                    Icons.square,
                    color: colors[index],
                  ),
                  sizeHor(5),
                  Text(
                    titles[index],
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              )),
    );
  }

  Container _buildBarChart(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Theme.of(context).highlightColor,
      width: (_timeGroupModels.length) ~/ 3 == 0 || _timeGroupModels.isEmpty
          ? MediaQuery.of(context).size.width
          : (_timeGroupModels.length * 120),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return _buildBarToolTipItem(rod, rodIndex, groupIndex, group);
            },
          )),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            show: true,
            bottomTitles: AxisTitles(
              axisNameWidget: Container(),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _buildGetTitlesWidget,
              ),
            ),
          ),
          gridData: const FlGridData(
            show: false,
          ),
          borderData: FlBorderData(
              show: true, border: const Border(bottom: BorderSide())),
          barGroups: _timeGroupModels.map(
            (timeGroupModel) {
              return BarChartGroupData(
                // barsSpace: 10,

                x: int.parse(
                    "${timeGroupModel.start.year}${timeGroupModel.start.month.toString().padLeft(2, "0")}${timeGroupModel.start.day.toString().padLeft(2, "0")}"),

                barRods: _setBarRods(timeGroupModel),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildGetTitlesWidget(value, meta) {
    final year = int.parse(value.toString().substring(0, 4));
    final month = int.parse(value.toString().substring(4, 6));
    final day = int.parse(value.toString().substring(6, 8));
    final date = DateTime(year, month, day);
    final dateString = _timeGroupType == TimeGroupType.week
        ? "${AppLocalizations.of(context)!.week}: ${weekNumber(date)}, ${DateFormat.y().format(date)}"
        : _dateFormat.format(date);

    return SideTitleWidget(axisSide: AxisSide.bottom, child: Text(dateString));
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  BarTooltipItem _buildBarToolTipItem(BarChartRodData rod, int rodIndex,
      int groupIndex, BarChartGroupData group) {
    final title;
    final date;
    final dateFormat;
    final amount;

    switch (rodIndex) {
      case 0:
        title = AppLocalizations.of(context)!.expense;
        amount = _timeGroupModels[groupIndex].expense;

        date = _timeGroupModels[groupIndex].start;
        dateFormat = DateFormat.yMMMEd().format(date);
        break;
      case 1:
        title = AppLocalizations.of(context)!.income;
        amount = _timeGroupModels[groupIndex].income;
        date = _timeGroupModels[groupIndex].start;
        dateFormat = DateFormat.yMMMEd().format(date);
        break;
      case 2:
        title = AppLocalizations.of(context)!.loss;
        amount = _timeGroupModels[groupIndex].loss;
        date = _timeGroupModels[groupIndex].start;
        dateFormat = DateFormat.yMMMEd().format(date);
        break;
      case 3:
        title = AppLocalizations.of(context)!.profit;
        amount = _timeGroupModels[groupIndex].profit;
        date = _timeGroupModels[groupIndex].start;
        dateFormat = DateFormat.yMMMEd().format(date);
        break;
      default:
        title = "";
        amount = 0;
        date = _timeGroupModels[groupIndex].start;
        dateFormat = DateFormat.yMMMEd().format(date);
    }
    return BarTooltipItem(
        title,
        const TextStyle(
          color: Colors.white,
        ),
        children: [
          TextSpan(text: "\n${_currencyFormat.format(amount)}"),
          TextSpan(text: "\n$dateFormat"),
        ]);
  }

  List<BarChartRodData> _setBarRods(TimeGroupModel timeGroupModel) {
    return [
      BarChartRodData(
        borderRadius: BorderRadius.circular(5),
        width: 20,
        color: Colors.orange,
        toY: _isIncome == false || _isIncome == null
            ? timeGroupModel.expense
            : 0,
      ),
      BarChartRodData(
          borderRadius: BorderRadius.circular(5),
          width: 20,
          color: Colors.blue,
          toY: _isIncome == true || _isIncome == null
              ? timeGroupModel.income
              : 0),
      BarChartRodData(
          borderRadius: BorderRadius.circular(5),
          width: 20,
          color: Colors.red,
          toY: _isIncome != null ? 0 : timeGroupModel.loss),
      BarChartRodData(
          borderRadius: BorderRadius.circular(5),
          width: 20,
          color: Colors.green,
          toY: _isIncome != null ? 0 : timeGroupModel.profit),
    ];
  }

  void setDateTimeIntervalType() {
    switch (_timeGroupType) {
      case TimeGroupType.day:
        _dateFormat = DateFormat.MMMEd();
        break;

      case TimeGroupType.week:
        _dateFormat = DateFormat('w');
        break;

      case TimeGroupType.month:
        _dateFormat = DateFormat.yMMM();
        break;

      case TimeGroupType.year:
        _dateFormat = DateFormat.y();
        break;

      default:
        _dateFormat = DateFormat.yMMM();
        break;
    }
  }

  PullDownButton _buildPullDwnBtn() {
    return PullDownButton(
      itemBuilder: (context) {
        return _accounts
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
            onPressed: showMenu, icon: const Icon(FontAwesomeIcons.wallet));
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(FontAwesomeIcons.bars)),
      centerTitle: true,
      title: Text(AppLocalizations.of(context)!.charts),
      actions: [
        _buildPullDwnBtn(),
      ],
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
        tabs: [
          Tab(
            child: Text(AppLocalizations.of(context)!.generalUpperCase),
          ),
          Tab(
            child: Text(AppLocalizations.of(context)!.expensesUpperCase),
          ),
          Tab(child: Text(AppLocalizations.of(context)!.incomeUpperCase)),
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
    } else if (groupType == TimeGroupType.year) {
      timeKey = "${transaction.date.year}";
    } else if (groupType == TimeGroupType.day) {
      timeKey =
          '${transaction.date.year}-${transaction.date.month}-${transaction.date.day}';
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
    } else if (groupType == TimeGroupType.year) {
      start = DateTime(int.parse(key));
      end = DateTime(int.parse(key));
    } else {
      List<int> dateParts = key.split('-').map(int.parse).toList();
      start = DateTime(dateParts[0], dateParts[1], dateParts[2]);
      end = start.add(const Duration(days: 6));
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
