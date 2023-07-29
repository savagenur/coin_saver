import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/usecases/exchange_rates/convert_currency_usecase.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:coin_saver/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../../../bloc/account/account_bloc.dart';

class CreateTransferPage extends StatefulWidget {
  final DateTime? selectedDate;
  const CreateTransferPage({super.key, this.selectedDate});

  @override
  State<CreateTransferPage> createState() => _CreateTransferPageState();
}

class _CreateTransferPageState extends State<CreateTransferPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AccountEntity? _accountFrom;
  AccountEntity? _accountTo;
  List<AccountEntity> _accounts = [];
  double _amountFrom = 0;
  double _amountTo = 0;
  double _exchangeRate = 0;
  late DateTime _selectedDate;
  final TextEditingController _amountFromController = TextEditingController();
  final TextEditingController _amountToController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _fromFocusNode = FocusNode();
  final FocusNode _toFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _amountListener();
  }

  void _amountListener() {
    _amountFromController.addListener(() {
      _convertCurrency();
    });
    _amountToController.addListener(() {
      _convertCurrency();
    });
  }

  void _setDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  void _convertCurrency() {
    if (_fromFocusNode.hasFocus) {
      _amountFrom = _amountFromController.text.isNotEmpty
          ? double.parse(_amountFromController.text)
          : 0;
      _exchangeRate = sl<ConvertCurrencyUsecase>()
          .call(_accountFrom!.currency.code, _accountTo!.currency.code);
      _amountTo = _amountFrom * _exchangeRate;
      setState(() {
        _amountToController.text = _amountTo.toStringAsFixed(2);
      });
    } else if (_toFocusNode.hasFocus) {
      _amountTo = _amountToController.text.isNotEmpty
          ? double.parse(_amountToController.text)
          : 0;
      _exchangeRate = sl<ConvertCurrencyUsecase>()
          .call(_accountTo!.currency.code, _accountFrom!.currency.code);
      _amountFrom = _amountTo * _exchangeRate;
      setState(() {
        _amountFromController.text = _amountFrom.toStringAsFixed(2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        if (accountState is AccountLoaded) {
          _accounts = accountState.accounts;
          return Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                ),
                title: const Text("Create transfer"),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeVer(10),
                    const Text(
                      "Transfer from account:",
                      style: TextStyle(color: Colors.grey),
                    ),
                    _buildToPullDownBtn(),
                    sizeVer(10),
                    const Text(
                      "Transfer to account:",
                      style: TextStyle(color: Colors.grey),
                    ),
                    _buildFromPullDownBtn(),
                    sizeVer(10),
                    const Text(
                      "Transfer amount:",
                      style: TextStyle(color: Colors.grey),
                    ),
                    sizeVer(10),
                    Row(
                      children: [
                        _buildFromAmount(context),
                        _accountFrom?.currency.code !=
                                    _accountTo?.currency.code &&
                                _accountFrom != null &&
                                _accountTo != null
                            ? _buildToAmount(context)
                            : Container(),
                      ],
                    ),
                    sizeVer(20),
                    const Text(
                      "Day:",
                      style: TextStyle(color: Colors.grey),
                    ),
                    sizeVer(5),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final firstDay = DateTime(2010);

                            return AlertDialog(
                              content: TransferCalendarWidget(
                                selectedDate: _selectedDate,
                                firstDay: firstDay,
                                setDate: _setDate,
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        DateFormat.yMMMEd().format(_selectedDate),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    sizeVer(20),
                    const Text(
                      "Comment:",
                      style: TextStyle(color: Colors.grey),
                    ),
                    sizeVer(5),
                    TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: "Comment",
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: MyButtonWidget(
                width: MediaQuery.of(context).size.width * .4,
                borderRadius: BorderRadius.circular(20),
                title: "Add",
                onTap: _buildAddTransfer,
              ),
            ),
          );
        }
        return const Scaffold();
      },
    );
  }

  PullDownButton _buildFromPullDownBtn() {
    return PullDownButton(
      itemBuilder: (context) {
        return _accounts
            .where((element) =>
                element.id != "total" &&
                element.id != _accountTo?.id &&
                element.id != _accountFrom?.id)
            .map(
              (account) => PullDownMenuItem.selectable(
                onTap: () {
                  setState(() {
                    _accountTo = account;
                    _amountFromController.clear();
                    _amountToController.clear();
                  });
                },
                title: account.name,
                icon: account.iconData,
                iconColor: Theme.of(context).primaryColor,
              ),
            )
            .toList();
      },
      buttonBuilder: (context, showMenu) {
        return TextButton.icon(
            onPressed: showMenu,
            icon: Icon(_accountTo != null
                ? _accountTo!.iconData
                : FontAwesomeIcons.circleExclamation),
            label: Text(
              _accountTo != null ? _accountTo!.name : "Not selected",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ));
      },
    );
  }

  PullDownButton _buildToPullDownBtn() {
    return PullDownButton(
      itemBuilder: (context) {
        return _accounts
            .where((element) =>
                element.id != "total" &&
                element.id != _accountTo?.id &&
                element.id != _accountFrom?.id)
            .map(
              (account) => PullDownMenuItem.selectable(
                onTap: () {
                  setState(() {
                    _accountFrom = account;
                    _amountFromController.clear();
                    _amountToController.clear();
                  });
                },
                title: account.name,
                icon: account.iconData,
                iconColor: Theme.of(context).primaryColor,
              ),
            )
            .toList();
      },
      buttonBuilder: (context, showMenu) {
        return TextButton.icon(
            onPressed: showMenu,
            icon: Icon(_accountFrom != null
                ? _accountFrom!.iconData
                : FontAwesomeIcons.circleExclamation),
            label: Text(
              _accountFrom != null ? _accountFrom!.name : "Not selected",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ));
      },
    );
  }

  Row _buildFromAmount(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .3,
          child: TextFormField(
            // initialValue:
            //     _amountFrom == 0 ? null : _amountFrom.round().toString(),
            focusNode: _fromFocusNode,
            controller: _amountFromController,
            validator: (value) {
              if (value == null || value.isEmpty || _amountFrom == 0) {
                return "Please enter\nvalid amount.";
              }
              return null;
            },
            enabled: _accountTo != null && _accountFrom != null,
            // onSaved: (newValue) {
            //   _amountFrom = double.parse(newValue!);
            // },

            maxLength: 20,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            maxLines: 1,
            textAlign: TextAlign.center,
            showCursor: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
            ],
            decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red.shade900),
              counterText: "",
              hintText: "0",
            ),
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
        Row(
          children: [
            sizeHor(3),
            Text(
              _accountFrom?.currency.code ??
                  _accounts
                      .firstWhere((element) => element.id == "total")
                      .currency
                      .code,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ],
    );
  }

  Row _buildToAmount(BuildContext context) {
    return Row(
      children: [
        Text(
          " = ",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).primaryColor),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .3,
          child: TextFormField(
            focusNode: _toFocusNode,
            controller: _amountToController,
            validator: (value) {
              if (value == null || value.isEmpty || _amountTo == 0) {
                return "Please enter\nvalid amount.";
              }
              return null;
            },
            // onSaved: (newValue) {
            //   _amountTo = double.parse(newValue!);
            // },
            maxLength: 20,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            maxLines: 1,
            textAlign: TextAlign.center,
            showCursor: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
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
        Row(
          children: [
            sizeHor(3),
            Text(
              _accountTo!.currency.code,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ],
    );
  }

  void _buildAddTransfer() {
    if (_formKey.currentState!.validate()) {
      final id = sl<Uuid>().v1();
      final TransactionEntity transaction = TransactionEntity(
        id: id,
        date: _selectedDate,
        amount: 0,
        category: CategoryEntity(
            id: "",
            name: "",
            iconData: Icons.abc,
            color: Colors.grey,
            isIncome: false,
            dateTime: _selectedDate),
        iconData: Icons.abc,
        accountId: "",
        isIncome: false,
        color: Colors.grey,
        // Transfer part
        isTransfer: true,
        accountFromId: _accountFrom!.id,
        accountToId: _accountTo!.id,
        amountFrom: _amountFrom,
        amountTo: _amountTo,
        description: _commentController.text,
      );
      context.read<AccountBloc>().add(
            AddTransfer(
                accountFrom: _accountFrom!,
                accountTo: _accountTo!,
                transactionEntity: transaction),
          );
      Navigator.pop(context);
    }
  }
}

class TransferCalendarWidget extends StatelessWidget {
  final void Function(DateTime) setDate;
  const TransferCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.firstDay,
    required this.setDate,
  });

  final DateTime selectedDate;
  final DateTime firstDay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar(
            focusedDay: selectedDate,
            firstDay: firstDay,
            lastDay: DateTime.now(),
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            onDaySelected: (selectedDay, focusedDay) {
              setDate(focusedDay);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
