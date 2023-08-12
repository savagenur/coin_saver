import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/constants/period_enum.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/entities/date/date_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/delete_transaction_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/period/period_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_category/selected_category_cubit.dart';
import 'package:coin_saver/features/presentation/pages/add_category/add_category_page.dart';
import 'package:coin_saver/features/presentation/pages/add_transaction/widget/calculator_page.dart';
import 'package:coin_saver/features/presentation/pages/home/home_page.dart';
import 'package:coin_saver/features/presentation/pages/transaction_detail/transaction_detail_page.dart';
import 'package:coin_saver/features/presentation/pages/transactions/transactions_page.dart';
import 'package:coin_saver/features/presentation/widgets/select_currency_widget.dart';
import 'package:coin_saver/features/presentation/widgets/simple_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../../../../injection_container.dart';
import '../../../domain/usecases/exchange_rates/convert_currency_usecase.dart';
import '../../bloc/cubit/selected_date/selected_date_cubit.dart';
import '../../bloc/home_time_period/home_time_period_bloc.dart';
import '../../bloc/main_transaction/main_transaction_bloc.dart';
import '../../widgets/my_button_widget.dart';

class AddTransactionPage extends StatefulWidget {
  final bool isIncome;
  final bool isTransactionsPage;
  final bool isMainTransactionPage;
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
    this.isTransactionsPage = false,
    this.isMainTransactionPage = false,
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
  double? _amountFrom;
  double? _exchangeRate;
  CurrencyEntity? _currencyFrom;
  CurrencyEntity? _currencyTotal;
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late final TextEditingController _amountFromController;

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

  void _setDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  // Category
  CategoryEntity? _category;

  // Blocs
  late SelectedCategoryCubit selectedCategoryCubit;
  late AccountBloc accountBloc;
  late HomeTimePeriodBloc homeTimePeriodBloc;
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
    periodCubit = context.read<PeriodCubit>();
    selectedDateCubit = context.read<SelectedDateCubit>();
    // First init
    _amount = widget.transaction?.amount ?? 0;
    _amountController = TextEditingController(
        text: _amount == 0 ? "" : _amount.round().toString());
    _amountFromController = TextEditingController(
        text: _amount == 0 ? "" : _amount.round().toString());
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
    _amountListener();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _amountFromController.dispose();
    _focusNode.dispose();
    _fromFocusNode.dispose();
    super.dispose();
  }

  void setAmount(double newValue) {
    setState(() {
      _amount = newValue;
      _amountController.text = newValue.toString();
    });
  }

  void setCurrency(CurrencyEntity? newValue) {
    setState(() {
      _currencyFrom = newValue;
    });
  }

  void _amountListener() {
    _amountFromController.addListener(() {
      _convertCurrency();
    });
    _amountController.addListener(() {
      _convertCurrency();
    });
  }

  void _convertCurrency() {
    if (_fromFocusNode.hasFocus) {
      _amountFrom = _amountFromController.text.isNotEmpty
          ? double.parse(_amountFromController.text)
          : 0;
      _exchangeRate = sl<ConvertCurrencyUsecase>().call(
          _currencyFrom!.code, _account?.currency.code ?? _currencyTotal!.code);
      _amount = (_amountFrom! * _exchangeRate!);
      setState(() {
        _amountController.text = _amount.toStringAsFixed(2);
      });
    } else if (_focusNode.hasFocus) {
      if (_currencyFrom != null) {
        _amount = _amountController.text.isNotEmpty
            ? double.parse(_amountController.text)
            : 0;
        _exchangeRate = sl<ConvertCurrencyUsecase>().call(
            _account?.currency.code ?? _currencyTotal!.code,
            _currencyFrom!.code);
        _amountFrom = _amount * _exchangeRate!;
        setState(() {
          _amountFromController.text = _amountFrom!.toStringAsFixed(2);
        });
      }
    }
  }

  final FocusNode _fromFocusNode = FocusNode();
  final FocusNode _focusNode = FocusNode();

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
                    _currencyTotal = _accounts
                        .firstWhere((element) => element.id == "total")
                        .currency;
                    return BlocBuilder<SelectedDateCubit, DateRange>(
                      builder: (context, dateRange) {
                        return BlocBuilder<SelectedCategoryCubit,
                            CategoryEntity?>(
                          builder: (context, selectedCategory) {
                            _category = selectedCategory;
                            return Form(
                              key: _formKey,
                              child: WillPopScope(
                                onWillPop: () async {
                                  if (widget.transaction != null) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else if (widget.isTransactionsPage) {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);
                                  }
                                  selectedCategoryCubit.changeCategory(null);
                                  return false;
                                },
                                child: DefaultTabController(
                                  length: 2,
                                  child: Scaffold(
                                    appBar: _buildAppBar(),
                                    body: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildInputAmount(context),
                                          sizeVer(5),
                                          _currencyFrom == null
                                              ? Container()
                                              : _buildInputAmount2(context),
                                          const Divider(),
                                          Expanded(
                                            child: Listener(
                                              onPointerDown: (_) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    sizeVer(10),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .account,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    sizeVer(5),
                                                    _buildPullDownButton(),
                                                    const Divider(),
                                                    sizeVer(10),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .categories,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Text(
                                                          isErrorCategory
                                                              ? AppLocalizations
                                                                      .of(context)!
                                                                  .pleaseSelectCategory
                                                              : "",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .error),
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
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .comment,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    sizeVer(10),
                                                    TextFormField(
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      controller:
                                                          _descriptionController,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .sentences,
                                                      maxLength: 4000,
                                                      minLines: 1,
                                                      maxLines: 6,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .comment,
                                                      ),
                                                    ),
                                                    sizeVer(70),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                            title: AppLocalizations.of(context)!
                                                .add,
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
                SimpleCalendarWidget(
                    selectedDate: _selectedDate,
                    firstDay: DateTime(2010),
                    lastDay: DateTime.now(),
                    setDate: _setDate)
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
              setState(() {
                _account = accounts[index];
              });
              isErrorAccount = false;
            },
            selected: accounts[index] == _account,
            title: accounts[index].name,
            subtitle: NumberFormat.compactCurrency(
                    symbol: accounts[index].currency.symbol)
                .format(accounts[index].balance),
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
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).primaryColor,
              ),
              sizeHor(5),
              Text(
                _account?.name ?? AppLocalizations.of(context)!.notSelected,
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
              focusNode: _focusNode,
              controller: _amountController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterValidAmount;
                }
                return null;
              },
              onSaved: (newValue) {
                _amount = double.parse(newValue!);
              },
              maxLength: 14,
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
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.selectCurrencyWidget,
                      arguments: SelectCurrencyWidget(
                          currency: _currencyTotal!, setCurrency: setCurrency));
                },
                child: Text(
                  _account == null
                      ? _currencyTotal!.code
                      : _account!.currency.code,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
              IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pushNamed(context, PageConst.calculatorPage,
                        arguments: CalculatorPage(
                          setAmount: setAmount,
                          currentValue: _amountController.text == ""
                              ? 0
                              : double.parse(_amountController.text),
                        ));
                  },
                  icon: const Icon(FontAwesomeIcons.calculator)),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildInputAmount2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(
          flex: 1,
        ),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: TextFormField(
                  focusNode: _fromFocusNode,
                  controller: _amountFromController,
                  maxLength: 14,
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
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              sizeHor(3),
              Text(
                _currencyFrom!.code,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
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
              accountBloc.add(
                  AddTransaction(transaction: transaction, account: _account!));
            }
            // Add the transaction to the new account
          } catch (e) {
            return;
          }
        } else {
          // Update the transaction within the same account

          accountBloc.add(
              UpdateTransaction(transaction: transaction, account: _account!));
        }
      } else {
        // Add a new transaction to the selected account

        accountBloc
            .add(AddTransaction(transaction: transaction, account: _account!));
      }

      // await Future.delayed(const Duration(milliseconds: 200));
      // accountBloc.add(GetAccounts());
      if (mounted) {
        // Set the selected account as the primary account
        // accountBloc.add(SetPrimaryAccount(accountId: _account!.id));

        // Clear the selected category
        selectedCategoryCubit.changeCategory(null);

        // Navigate to the appropriate screen based on the widget type
        if (widget.isTransactionsPage) {
          // If it's an existing transaction, pop back to the previous screen(s)
          Navigator.popUntil(context,
              (route) => route.settings.name == PageConst.transactionsPage);
        } else if (widget.transaction != null) {
          Navigator.pushNamedAndRemoveUntil(
              context,
              PageConst.transactionDetailPage,
              arguments: TransactionDetailPage(
                  transaction: transaction, account: _account!),
              (route) =>
                  route.settings.name == PageConst.transactionsPage ||
                  route.settings.name == PageConst.mainTransactionPage);
          // Navigator.pop(context);
        } else if (widget.isMainTransactionPage) {
          Navigator.pop(context, true);
        } else {
          // If it's a new transaction, navigate to the home page with the appropriate arguments
          Navigator.pop(context, true);
        }
      }
    }
  }

  String formattedDate(DateTime dateTime) {
    return DateFormat("dd/MM").format(dateTime);
  }

  Padding _buildSelectDay(BuildContext context, int selectedDay) {
    final List<DateEntity> days = [
      DateEntity(name: AppLocalizations.of(context)!.today, dateTime: today),
      DateEntity(
          name: AppLocalizations.of(context)!.yesterday, dateTime: yesterday),
      // Checks two days ago or selected day
      formattedDate(twoDaysAgo) == formattedDate(_selectedDate) ||
              formattedDate(yesterday) == formattedDate(_selectedDate) ||
              formattedDate(today) == formattedDate(_selectedDate)
          ? DateEntity(
              name: AppLocalizations.of(context)!.twoDaysAgo,
              dateTime: twoDaysAgo)
          : DateEntity(
              name: AppLocalizations.of(context)!.selectedDay,
              dateTime: _selectedDate),
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
                            _selectedDate = day.dateTime!;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: DateFormat.yMd().format(_selectedDate) ==
                                    DateFormat.yMd().format(day.dateTime!)
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.background,
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
            child: Column(
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
                  AppLocalizations.of(context)!.more,
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
            Navigator.pop(context);

            selectedCategoryCubit.changeCategory(null);
          },
          icon: const Icon(FontAwesomeIcons.arrowLeft)),
      title: Text(AppLocalizations.of(context)!.addTransactions),
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
        tabs: [
          Tab(
            child: Text(AppLocalizations.of(context)!.expensesUpperCase),
          ),
          Tab(child: Text(AppLocalizations.of(context)!.incomeUpperCase)),
        ],
      ),
    );
  }
}
