import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/date/date_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/usecases/main_transaction/get_main_transactions_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/main_time_period/main_time_period_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/main_transaction/main_transaction_bloc.dart';
import 'package:coin_saver/features/presentation/pages/add_category/add_category_page.dart';
import 'package:coin_saver/features/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:coin_saver/injection_container.dart' as di;
import '../../../data/models/transaction/transaction_model.dart';
import '../../widgets/my_button_widget.dart';

class AddTransactionPage extends StatefulWidget {
  final bool isIncome;
  final AccountEntity account;
  final DateTime dateTime;
  const AddTransactionPage(
      {super.key,
      required this.isIncome,
      required this.account,
      required this.dateTime});

  @override
  State<AddTransactionPage> createState() => AddTransactionPageState();
}

class AddTransactionPageState extends State<AddTransactionPage>
    with SingleTickerProviderStateMixin {
  AccountEntity? _account;
  late DateTime _dateTime;
  late bool _isIncome;
  late List<TransactionEntity> _transactionHistory;
  late TabController _tabController;
  late List<CategoryEntity> _categories;
  int _selectedDay = 0;
  double _amount = 0;
  final TextEditingController _textEditingController = TextEditingController();

  // DateTime vars
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  DateTime today = DateTime.now();
  DateTime twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
  void selectDay() {
    if (_dateTime.month == yesterday.month && _dateTime.day == yesterday.day) {
      _selectedDay = 1;
    } else if (_dateTime.month <= twoDaysAgo.month &&
        _dateTime.day != yesterday.day &&
        _dateTime.day != today.day) {
      _selectedDay = 2;
    }
  }

  // Category
  CategoryEntity? _category;
  int? _selectedCategoryIndex;
  @override
  void initState() {
    super.initState();
    // Controls isIncome tab or not
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.isIncome ? 1 : 0);
    _account = widget.account;
    _dateTime = widget.dateTime;
    _isIncome = widget.isIncome;
    _transactionHistory = widget.account.transactionHistory;
    // DateTime select init
    selectDay();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        if (categoryState is CategoryLoaded) {
          _categories = categoryState.categories
              .where((category) => category.isIncome == _isIncome)
              .toList();
          _selectedCategoryIndex != null
              ? _category = _categories[_selectedCategoryIndex!]
              : _category;

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: _buildAppBar(),
              body: Padding(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .3,
                              child: TextFormField(
                                controller: _textEditingController,
                                maxLength: 10,
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                showCursor: false,
                                decoration: InputDecoration(hintText: "0"),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  "USD",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.calculate_outlined)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      sizeVer(20),
                      const Text(
                        "Account:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          _account!.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Divider(),
                      sizeVer(10),
                      Text(
                        "Categories:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      sizeVer(10),
                      _buildGridView(_categories),
                      Divider(),
                      sizeVer(10),
                      _buildSelectDay(context, _selectedDay),
                      sizeVer(20),
                      Text(
                        "Comment:",
                        style: TextStyle(color: Colors.grey),
                      ),
                      sizeVer(10),
                      TextFormField(
                        maxLength: 4000,
                        decoration: InputDecoration(
                          hintText: "Comment...",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton:
                  MediaQuery.of(context).viewInsets.bottom != 0
                      ? null
                      : MyButtonWidget(
                          title: 'Add',
                          width: MediaQuery.of(context).size.width * .5,
                          borderRadius: BorderRadius.circular(30),
                          paddingVertical: 15,
                          onTap: _textEditingController.text.isEmpty ||
                                  _category == null ||
                                  _account == null
                              ? null
                              : _buildAddTransaction),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
          );
        }
      },
    );
  }

  _buildAddTransaction() async {
    _amount = double.parse(_textEditingController.text);
    var id = const Uuid().v1();
    _transactionHistory = [..._account!.transactionHistory];
    _transactionHistory.add(TransactionModel(
      id: id,
      date: _dateTime,
      amount: double.parse(_textEditingController.text),
      category: _category!.name,
      account: _account!.name,
      isIncome: _isIncome,
      color: _category!.color,
    ));
    context.read<MainTransactionBloc>().add(CreateMainTransaction(
        mainTransaction: MainTransactionEntity(
            id: "",
            accountId: _account!.id,
            name: _category!.name,
            iconData: _category!.iconData,
            color: _category!.color,
            totalAmount: _amount,
            isIncome: _isIncome,
            dateTime: _dateTime)));
    AccountEntity account = AccountEntity(
        id: _account!.id,
        name: _account!.name,
        type: _account!.type,
        balance: _isIncome
            ? _account!.balance + _amount
            : _account!.balance - _amount,
        currency: _account!.currency,
        isPrimary: _account!.isPrimary,
        isActive: _account!.isActive,
        ownershipType: _account!.ownershipType,
        openingDate: _account!.openingDate,
        transactionHistory: _transactionHistory);
    context.read<AccountBloc>().add(UpdateAccount(accountEntity: account));
    final mainTransactions = await di.sl<GetMainTransactionsUsecase>().call();
   if (context.mounted) {
      BlocProvider.of<MainTimePeriodBloc>(context).add(
        SetDayPeriod(selectedDate: _dateTime, ));
    Navigator.pushNamed(context, PageConst.homePage,
        arguments: HomePage(
          dateTime: _dateTime,
          isIncome: _isIncome,
        ));
   }
  }

  Padding _buildSelectDay(BuildContext context, int selectedDay) {
    final List<DateEntity> days = [
      DateEntity(name: "today", dateTime: today),
      DateEntity(name: "yesterday", dateTime: yesterday),
      // Checks two days ago or selected day
      DateFormat("dd/MM").format(twoDaysAgo) ==
                  DateFormat("dd/MM").format(_dateTime) &&
              DateFormat("dd/MM").format(yesterday) ==
                  DateFormat("dd/MM").format(yesterday) &&
              DateFormat("dd/MM").format(today) ==
                  DateFormat("dd/MM").format(today)
          ? DateEntity(name: "two days ago", dateTime: twoDaysAgo)
          : DateEntity(name: "selected day", dateTime: _dateTime),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ...List.generate(
                  days.length,
                  (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDay = index;
                            _dateTime = days[index].dateTime!;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: selectedDay == index
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat("dd/MM")
                                    .format(days[index].dateTime!),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: selectedDay == index
                                            ? Colors.white
                                            : null),
                              ),
                              Text(
                                days[index].name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: selectedDay == index
                                            ? Colors.white
                                            : Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )),
            ],
          ),
          IconButton(
              onPressed: () {
                print(_account!.transactionHistory.length);
              },
              icon: Icon(Icons.calendar_month))
        ],
      ),
    );
  }

  GridView _buildGridView(List<CategoryEntity> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, mainAxisSpacing: 5, crossAxisSpacing: 5),
      itemCount: categories.length < 8 ? categories.length + 1 : 8,
      itemBuilder: (BuildContext context, int index) {
        if (index == categories.length) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PageConst.addCategoryPage,
                  arguments: AddCategoryPage(
                    isIncome: _isIncome,
                    categories: categories,
                  ));
            },
            child: const Column(
              children: [
                CircleAvatar(
                  backgroundColor: secondaryColor,
                  radius: 25,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "More",
                  maxLines: 1,
                ),
              ],
            ),
          );
        } else {
          CategoryEntity categoryEntity = categories[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
                _category = categories[index];
                print(_category!.name);
              });
            },
            child: index == _selectedCategoryIndex
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: categoryEntity.color,
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: categoryEntity.color,
                          child: Icon(
                            categoryEntity.iconData,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        categoryEntity.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: categoryEntity.color,
                        child: Icon(
                          categoryEntity.iconData,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        categoryEntity.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
          );
        }
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text("Add Transactions"),
      bottom: TabBar(
        controller: _tabController,
        onTap: (value) {
          switch (value) {
            case 0:
              setState(() {
                _isIncome = false;
              });
              break;
            case 1:
              setState(() {
                _isIncome = true;
              });
              break;
            default:
          }
          setState(() {
            // Unselect category
            _selectedCategoryIndex = null;
            _category = null;
          });
        },
        padding: const EdgeInsets.symmetric(horizontal: 20),
        indicatorPadding: const EdgeInsets.only(bottom: 5),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(
            child: Text("EXPENSES"),
          ),
          Tab(child: Text("INCOME")),
        ],
      ),
    );
  }
}
