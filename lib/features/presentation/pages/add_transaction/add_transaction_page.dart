import 'package:auto_size_text/auto_size_text.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/constants/period_enum.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/date/date_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/usecases/account/set_primary_account_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_category/selected_category_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/pages/add_category/add_category_page.dart';
import 'package:coin_saver/features/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:uuid/uuid.dart';
import '../../../../injection_container.dart';
import '../../bloc/cubit/selected_date/selected_date_cubit.dart';
import '../../bloc/main_transaction/main_transaction_bloc.dart';
import '../../bloc/time_period/time_period_bloc.dart';
import '../../widgets/my_button_widget.dart';

class AddTransactionPage extends StatefulWidget {
  final bool isIncome;
  final AccountEntity account;
  final DateTime selectedDate;
  const AddTransactionPage({
    super.key,
    required this.isIncome,
    required this.account,
    required this.selectedDate,
  });

  @override
  State<AddTransactionPage> createState() => AddTransactionPageState();
}

class AddTransactionPageState extends State<AddTransactionPage>
    with SingleTickerProviderStateMixin {
  AccountEntity? _account;
  late String _selectedAccountId;
  late List<AccountEntity> _accounts;
  late DateTime _selectedDate;
  late bool _isIncome;
  late List<TransactionEntity> _transactionHistory;
  late TabController _tabController;
  late List<CategoryEntity> _categories;
  int _selectedDay = 0;
  double _amount = 0;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // DateTime vars
  DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
  DateTime today = DateTime.now();
  DateTime twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
  void selectDay() {
    if (_selectedDate.month == yesterday.month &&
        _selectedDate.day == yesterday.day) {
      _selectedDay = 1;
    } else if (_selectedDate.month <= twoDaysAgo.month &&
        _selectedDate.day != yesterday.day &&
        _selectedDate.day != today.day) {
      _selectedDay = 2;
    }
  }

  // Category
  CategoryEntity? _category;

  // Blocs
  late SelectedCategoryCubit selectedCategoryCubit;
  late AccountBloc accountBloc;
  late TimePeriodBloc timePeriodBloc;
  late MainTransactionBloc mainTransactionBloc;
  late PeriodCubit periodCubit;
  late SelectedDateCubit selectedDateCubit;

  // Validness checker
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isErrorCategory = false;
  bool isErrorAccount = false;

  @override
  void initState() {
    super.initState();
    // SelectedDate
    _selectedDate = widget.selectedDate;
    // Controls isIncome tab or not
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.isIncome ? 1 : 0);
    if (widget.account.id == "total") {
      _account = null;
    } else {
      _account = widget.account;
    }
    _selectedAccountId = widget.account.id;
    _isIncome = widget.isIncome;
    _transactionHistory = widget.account.transactionHistory;
    // DateTime select init
    selectDay();

    // Blocs
    selectedCategoryCubit = context.read<SelectedCategoryCubit>();
    accountBloc = context.read<AccountBloc>();
    timePeriodBloc = context.read<TimePeriodBloc>();
    mainTransactionBloc = context.read<MainTransactionBloc>();
    periodCubit = context.read<PeriodCubit>();
    selectedDateCubit = context.read<SelectedDateCubit>();
  }

  @override
  void didUpdateWidget(covariant AddTransactionPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if _category and _account are not null
    if (_category == null && _account == null) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        if (accountState is AccountLoaded) {
          _accounts = accountState.accounts;
          return BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, categoryState) {
              if (categoryState is CategoryLoaded) {
                _categories = categoryState.categories
                    .where((category) => category.isIncome == _isIncome)
                    .toList();
                _categories.sort(
                  (a, b) => b.dateTime.compareTo(a.dateTime),
                );

                return BlocBuilder<SelectedDateCubit, DateTime>(
                  builder: (context, selectedDate) {
                    _selectedDate = selectedDate;
                    return BlocBuilder<SelectedCategoryCubit, CategoryEntity?>(
                      builder: (context, selectedCategory) {
                        _category = selectedCategory;
                        return Form(
                          key: _formKey,
                          child: DefaultTabController(
                            length: 2,
                            child: Scaffold(
                              appBar: _buildAppBar(),
                              body: Padding(
                                padding: const EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildInputAmount(context),
                                      sizeVer(10),
                                      const Text(
                                        "Account:",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      sizeVer(5),
                                      _buildPullDownButton(),
                                      const Divider(),
                                      sizeVer(10),
                                      Row(
                                        children: [
                                          const Text(
                                            "Categories:",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            isErrorCategory
                                                ? " Please Select Category"
                                                : "",
                                            style: TextStyle(
                                                color: Colors.red.shade900),
                                          ),
                                        ],
                                      ),
                                      sizeVer(10),
                                      _buildGridView(_categories),
                                      const Divider(),
                                      sizeVer(10),
                                      _buildSelectDay(context, _selectedDay),
                                      sizeVer(20),
                                      const Text(
                                        "Comment:",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      sizeVer(10),
                                      TextFormField(
                                        controller: _descriptionController,
                                        maxLength: 4000,
                                        decoration: const InputDecoration(
                                          hintText: "Comment...",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              floatingActionButtonLocation:
                                  FloatingActionButtonLocation.centerDocked,
                              floatingActionButton: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom !=
                                      0
                                  ? null
                                  : MyButtonWidget(
                                      title: 'Add',
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                      borderRadius: BorderRadius.circular(30),
                                      paddingVertical: 15,
                                      onTap: _buildAddTransaction),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return Scaffold(
                  appBar: AppBar(),
                );
              }
            },
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }

  PullDownButton _buildPullDownButton() {
    return PullDownButton(
      itemBuilder: (context) {
        List<AccountEntity> accounts =
            _accounts.where((element) => element.id != "total").toList();
        return List.generate(
          _accounts.length - 1,
          (index) => PullDownMenuItem.selectable(
            onTap: () {
              _account = accounts[index];
              isErrorAccount = false;
              // accountBloc.add(SetPrimaryAccount(accountId: _account!.id));
            },
            selected: accounts[index] == _account,
            title: accounts[index].name,
            subtitle: "\$${accounts[index].balance}",
            icon: accounts[index].iconData,
          ),
        );
      },
      buttonBuilder: (context, showMenu) {
        return GestureDetector(
          onTap: showMenu,
          child: Row(
            children: [
              Icon(
                _account?.iconData ?? FontAwesomeIcons.circleExclamation,
                color: isErrorAccount
                    ? Colors.red.shade800
                    : Theme.of(context).primaryColor,
              ),
              sizeHor(5),
              Text(
                _account?.name ?? "Not selected!",
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

  Row _buildInputAmount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(
          flex: 1,
        ),
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .3,
            child: TextFormField(
              controller: _amountController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter\nvalid amount.";
                }
                return null;
              },
              onSaved: (newValue) {
                _amount = double.parse(newValue!);
              },
              maxLength: 12,
              autofocus: true,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              maxLines: 1,
              textAlign: TextAlign.center,
              showCursor: false,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              decoration: InputDecoration(
                counterText: "",
                hintText: "0",
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
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
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.calculate_outlined)),
            ],
          ),
        ),
      ],
    );
  }

  _buildAddTransaction() async {
    if (_category == null) {
      setState(() {
        isErrorCategory = true;
      });
    }
    if (_account == null) {
      setState(() {
        isErrorAccount = true;
      });
    }
    if (_formKey.currentState!.validate() &&
        _category != null &&
        _account != null) {
      _formKey.currentState!.save();
      final TransactionEntity transaction = TransactionEntity(
        id: sl<Uuid>().v1(),
        date: _selectedDate,
        amount: _amount,
        category: _category!,
        iconData: _category!.iconData,
        accountId: _account!.name,
        isIncome: _isIncome,
        color: _category!.color,
      );

      mainTransactionBloc
          .add(AddTransaction(transaction: transaction, account: _account!));
      accountBloc.add(
        SetPrimaryAccount(accountId: _account!.id),
      );
      timePeriodBloc.add(SetDayPeriod(
        selectedDate: _selectedDate,
      ));

      periodCubit.changePeriod(Period.day);
      selectedCategoryCubit.changeCategory(null);
      Navigator.pushNamed(context, PageConst.homePage,
          arguments: HomePage(
            dateTime: _selectedDate,
            isIncome: _isIncome,
          ));
    }
  }

  String formattedDate(DateTime dateTime) {
    return DateFormat("dd/MM").format(dateTime);
  }

  Padding _buildSelectDay(BuildContext context, int selectedDay) {
    final List<DateEntity> days = [
      DateEntity(name: "today", dateTime: today),
      DateEntity(name: "yesterday", dateTime: yesterday),
      // Checks two days ago or selected day
      formattedDate(twoDaysAgo) == formattedDate(_selectedDate) ||
              formattedDate(yesterday) == formattedDate(_selectedDate) ||
              formattedDate(today) == formattedDate(_selectedDate)
          ? DateEntity(name: "two days ago", dateTime: twoDaysAgo)
          : DateEntity(name: "selected day", dateTime: _selectedDate),
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
                            _selectedDate = days[index].dateTime!;
                            context
                                .read<SelectedDateCubit>()
                                .changeDate(_selectedDate);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: selectedDay == index
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(right: 10),
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_month))
        ],
      ),
    );
  }

  GridView _buildGridView(
    List<CategoryEntity> categories,
  ) {
    final displayList = categories.take(7).toList();
    displayList.add(displayList.last.copyWith(name: "null"));
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, mainAxisSpacing: 5, crossAxisSpacing: 5),
      itemCount: displayList.length,
      itemBuilder: (BuildContext context, int index) {
        final item = displayList[index];
        if (item.name == "null") {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PageConst.addCategoryPage,
                  arguments: AddCategoryPage(
                    isIncome: _isIncome,
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
              selectedCategoryCubit.changeCategory(categoryEntity);
              isErrorCategory = false;
            },
            child: _category != null && _category!.id == categoryEntity.id
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
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
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            selectedCategoryCubit.changeCategory(null);
          },
          icon: const Icon(Icons.arrow_back)),
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
          selectedCategoryCubit.changeCategory(null);
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
