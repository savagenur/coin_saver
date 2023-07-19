import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/constants/period_enum.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/date/date_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/delete_transaction_usecase.dart';
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
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';
import '../../../../injection_container.dart';
import '../../bloc/cubit/selected_date/selected_date_cubit.dart';
import '../../bloc/home_time_period/home_time_period_bloc.dart';
import '../../bloc/main_transaction/main_transaction_bloc.dart';
import '../../widgets/my_button_widget.dart';

class AddTransactionPage extends StatefulWidget {
  final bool isIncome;
  final AccountEntity account;
  final DateTime selectedDate;
  final TransactionEntity? transaction;
  final CategoryEntity? category;
  const AddTransactionPage({
    super.key,
    required this.isIncome,
    required this.account,
    required this.selectedDate,
    this.transaction,
    this.category,
  });

  @override
  State<AddTransactionPage> createState() => AddTransactionPageState();
}

class AddTransactionPageState extends State<AddTransactionPage>
    with SingleTickerProviderStateMixin {
  AccountEntity? _account;
  late List<AccountEntity> _accounts;
  late DateTime _selectedDate;
  late bool _isIncome;
  late Period _selectedPeriod;
  late TabController _tabController;
  late List<CategoryEntity> _categories;
  int _selectedDay = 0;
  late double _amount;
  late final TextEditingController _descriptionController;

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
  late HomeTimePeriodBloc homeTimePeriodBloc;
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
    // Blocs
    selectedCategoryCubit = context.read<SelectedCategoryCubit>();
    accountBloc = context.read<AccountBloc>();
    homeTimePeriodBloc = context.read<HomeTimePeriodBloc>();
    mainTransactionBloc = context.read<MainTransactionBloc>();
    periodCubit = context.read<PeriodCubit>();
    selectedDateCubit = context.read<SelectedDateCubit>();
    // First init
    _amount = widget.transaction?.amount ?? 0;

    _descriptionController =
        TextEditingController(text: widget.transaction?.description);
    selectedCategoryCubit.changeCategory(widget.category);

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
    _isIncome = widget.isIncome;
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
    return BlocBuilder<PeriodCubit, Period>(
      builder: (context, selectedPeriod) {
        _selectedPeriod = selectedPeriod;
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

                    return BlocBuilder<SelectedDateCubit, DateRange>(
                      builder: (context, dateRange) {
                        _selectedDate = dateRange.startDate;

                        return BlocBuilder<SelectedCategoryCubit,
                            CategoryEntity?>(
                          builder: (context, selectedCategory) {
                            _category = selectedCategory;
                            return Form(
                              key: _formKey,
                              child: WillPopScope(
                                onWillPop: () async {
                                  await Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      PageConst.homePage,
                                      arguments: HomePage(
                                        period: _selectedPeriod,
                                        isIncome: _isIncome,
                                      ),
                                      (route) =>
                                          route.settings.name ==
                                          PageConst.homePage);
                                  selectedCategoryCubit.changeCategory(null);
                                  return false;
                                },
                                child: DefaultTabController(
                                  length: 2,
                                  child: Scaffold(
                                    appBar: _buildAppBar(),
                                    body: Listener(
                                      onPointerDown: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildInputAmount(context),
                                            const Divider(),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    sizeVer(10),
                                                    const Text(
                                                      "Account:",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    sizeVer(5),
                                                    _buildPullDownButton(),
                                                    const Divider(),
                                                    sizeVer(10),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Categories:",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Text(
                                                          isErrorCategory
                                                              ? " Please Select Category"
                                                              : "",
                                                          style: TextStyle(
                                                              color: Colors.red
                                                                  .shade900),
                                                        ),
                                                      ],
                                                    ),
                                                    sizeVer(10),
                                                    _buildGridView(_categories),
                                                    const Divider(),
                                                    sizeVer(10),
                                                    _buildSelectDay(
                                                        context, _selectedDay),
                                                    sizeVer(20),
                                                    const Text(
                                                      "Comment:",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    sizeVer(10),
                                                    TextFormField(
                                                      controller:
                                                          _descriptionController,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .sentences,
                                                      maxLength: 4000,
                                                      minLines: 1,
                                                      maxLines: 6,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: "Comment...",
                                                      ),
                                                    ),
                                                    sizeVer(30),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    floatingActionButtonLocation:
                                        FloatingActionButtonLocation
                                            .centerDocked,
                                    floatingActionButton: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom !=
                                            0
                                        ? null
                                        : MyButtonWidget(
                                            title: 'Add',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            paddingVertical: 15,
                                            onTap: _buildAddTransaction),
                                  ),
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
      },
    );
  }

  void _buildShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width:
                MediaQuery.of(context).size.width * .9, // Set the desired width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<SelectedDateCubit, DateRange>(
                  builder: (context, dateRange) {
                    var selectedDate = dateRange.startDate;
                    return TableCalendar(
                      weekNumbersVisible: true,
                      headerStyle:
                          const HeaderStyle(formatButtonVisible: false),
                      focusedDay: selectedDate,
                      firstDay: DateTime(2000),
                      lastDay: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      currentDay: selectedDate,
                      onDaySelected: (selectedDay, focusedDay) {
                        DateTime selectedDayConverted = DateTime(
                            selectedDay.year,
                            selectedDay.month,
                            selectedDay.day);
                        Navigator.pop(context);

                        context
                            .read<SelectedDateCubit>()
                            .changeStartDate(selectedDayConverted);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
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
              initialValue: _amount == 0 ? null : _amount.round().toString(),
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              maxLines: 1,
              textAlign: TextAlign.center,
              showCursor: false,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              decoration: const InputDecoration(
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
              sizeHor(3),
              Text(
                _accounts
                    .firstWhere((element) => element.id == "main")
                    .currency
                    .code,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(FontAwesomeIcons.calculator)),
            ],
          ),
        ),
      ],
    );
  }

  void _buildAddTransaction() async {
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

    // Check for form validation and category/account selection
    if (_formKey.currentState!.validate() &&
        _category != null &&
        _account != null) {
      _formKey.currentState!.save();

      final TransactionEntity transaction = TransactionEntity(
        id: widget.transaction != null
            ? widget.transaction!.id
            : sl<Uuid>().v1(),
        date: _selectedDate,
        amount: _amount,
        category: _category!,
        iconData: _category!.iconData,
        accountId: _account!.name,
        isIncome: _isIncome,
        color: _category!.color,
        description: _descriptionController.text,
      );

      if (widget.transaction != null) {
        if (_account!.id != widget.account.id) {
          // Move the delete and add transaction calls inside a try-catch block
          try {
            // Delete the transaction from the old account
            await sl<DeleteTransactionUsecase>()
                .call(widget.account, widget.transaction!);
            if (mounted) {
              BlocProvider.of<MainTransactionBloc>(context).add(
                  AddTransaction(transaction: transaction, account: _account!));
            }
            // Add the transaction to the new account
          } catch (e) {
            // Handle the error, show a snackbar, or revert changes if needed
            // ...
            return;
          }
        } else {
          // Update the transaction within the same account
          BlocProvider.of<MainTransactionBloc>(context).add(
              UpdateTransaction(transaction: transaction, account: _account!));
        }
      } else {
        // Add a new transaction to the selected account
        BlocProvider.of<MainTransactionBloc>(context)
            .add(AddTransaction(transaction: transaction, account: _account!));
      }

      if (mounted) {
        // Set the selected account as the primary account
      accountBloc
          .add(SetPrimaryAccount(accountId: _account!.id));

      // Set the selected date as the day period
      homeTimePeriodBloc
          .add(SetDayPeriod(selectedDate: _selectedDate));

      // Change the period to 'day' in the PeriodCubit
      periodCubit.changePeriod(Period.day);

      // Clear the selected category
      selectedCategoryCubit.changeCategory(null);

      // Navigate to the appropriate screen based on the widget type
      if (widget.transaction != null) {
        // If it's an existing transaction, pop back to the previous screen(s)
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        // If it's a new transaction, navigate to the home page with the appropriate arguments
        Navigator.pushNamed(context, PageConst.homePage,
            arguments: HomePage(isIncome: _isIncome));
      }
      }
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
              ...days
                  .map((day) => GestureDetector(
                        onTap: () {
                          setState(() {
                            context
                                .read<SelectedDateCubit>()
                                .changeStartDate(day.dateTime!);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: DateFormat.yMd().format(_selectedDate) ==
                                    DateFormat.yMd().format(day.dateTime!)
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat("dd/MM").format(day.dateTime!),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: DateFormat.yMd()
                                                    .format(_selectedDate) ==
                                                DateFormat.yMd()
                                                    .format(day.dateTime!)
                                            ? Colors.white
                                            : null),
                              ),
                              Text(
                                day.name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: DateFormat.yMd()
                                                    .format(_selectedDate) ==
                                                DateFormat.yMd()
                                                    .format(day.dateTime!)
                                            ? Colors.white
                                            : Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
          IconButton(
              onPressed: () => _buildShowDialog(context),
              icon: const Icon(Icons.calendar_month))
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
                    FontAwesomeIcons.plus,
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
          onPressed: () async {
            widget.transaction == null
                ? Navigator.pop(context)
                : await Navigator.pushNamedAndRemoveUntil(
                    context,
                    PageConst.homePage,
                    arguments: HomePage(
                      period: _selectedPeriod,
                      isIncome: _isIncome,
                    ),
                    (route) => route.settings.name == PageConst.homePage);
            selectedCategoryCubit.changeCategory(null);
          },
          icon: const Icon(FontAwesomeIcons.arrowLeft)),
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
