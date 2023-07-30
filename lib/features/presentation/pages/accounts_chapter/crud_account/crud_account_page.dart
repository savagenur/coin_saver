import 'package:coin_saver/constants/account_icons.dart';
import 'package:coin_saver/constants/currencies.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/usecases/account/create_account_usecase.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/main_colors/main_colors_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_color/selected_color_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_icon/selected_icon_cubit.dart';
import 'package:coin_saver/features/presentation/pages/home/home_page.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:uuid/uuid.dart';

import '../../../../../constants/constants.dart';
import '../../../../../injection_container.dart';
import '../../../../domain/entities/transaction/transaction_entity.dart';

class CRUDAccountPage extends StatefulWidget {
  final bool isUpdatePage;
  final AccountEntity? account;
  final CurrencyEntity mainCurrency;
  const CRUDAccountPage({
    super.key,
    this.isUpdatePage = false,
    this.account,
    required this.mainCurrency,
  });

  @override
  State<CRUDAccountPage> createState() => CRUDAccountPageState();
}

class CRUDAccountPageState extends State<CRUDAccountPage> {
  late double _balance;
  late String _accountName;
  late bool _isUpdatePage;
  late AccountEntity? _account;
  late CurrencyEntity _currency;
  IconData? _iconData;
  Color? _color;
  final ScrollController _colorController = ScrollController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SelectedIconCubit selectedIconCubit;
  late SelectedColorCubit selectedColorCubit;
  late AccountBloc accountBloc;
  bool _isErrorIcon = false;
  bool _isErrorColor = false;

  @override
  void initState() {
    super.initState();
    _isUpdatePage = widget.isUpdatePage;
    _account = widget.account;
    _balance = widget.account?.balance ?? 0;
    _accountName = widget.account?.name ?? "";
    _amountController.text = _balance.toStringAsFixed(2).toString();
    _amountFocusNode.addListener(_onFocusChange);
    _currency = _account?.currency ?? widget.mainCurrency;
    selectedIconCubit = context.read<SelectedIconCubit>();
    selectedColorCubit = context.read<SelectedColorCubit>();
    accountBloc = context.read<AccountBloc>();
    if (widget.account != null) {
      selectedIconCubit.changeIcon(widget.account?.iconData);
      selectedColorCubit.changeColor(widget.account?.color);
    }
  }

  @override
  void dispose() {
    _amountFocusNode.removeListener(_onFocusChange);
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_amountFocusNode.hasFocus && _balance == 0) {
      setState(() {
        _amountController.text = "";
      });
    } else if (!_amountFocusNode.hasFocus && _amountController.text == "" ||
        _amountController.text == "-") {
      setState(() {
        _amountController.text = "0";
      });
    } else {
      _balance = double.parse(_amountController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectedColorCubit.changeColor(null);
        selectedIconCubit.changeIcon(null);
        Navigator.pop(context);
        return false;
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  selectedColorCubit.changeColor(null);
                  selectedIconCubit.changeIcon(null);
                  Navigator.pop(context);
                },
                icon: const Icon(FontAwesomeIcons.arrowLeft)),
            title: Text(_isUpdatePage ? "Update account" : "Add account"),
          ),
          body: BlocBuilder<SelectedColorCubit, Color?>(
            builder: (context, selectedColor) {
              return BlocBuilder<MainColorsCubit, MainColorsState>(
                builder: (context, mainColorsState) {
                  if (mainColorsState is MainColorsLoaded) {
                    return BlocBuilder<SelectedIconCubit, IconData?>(
                      builder: (context, selectedIcon) {
                        _iconData = selectedIcon;
                        _color = selectedColor;
                        return Listener(
                          onPointerDown: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sizeVer(10),
                                _buildInputAmount(context),
                                sizeVer(20),
                                const Text(
                                  "Account name:",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                sizeVer(10),
                                TextFormField(
                                  initialValue: _accountName,
                                  autofocus: true,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return " Please enter account name";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) =>
                                      _accountName = newValue!,
                                  decoration: const InputDecoration(
                                      hintText: "Enter account name"),
                                ),
                                sizeVer(20),
                                Row(
                                  children: [
                                    const Text(
                                      "Icons:",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    _isErrorIcon
                                        ? Text(
                                            " Please select icon",
                                            style: TextStyle(
                                                color: Colors.red.shade900),
                                          )
                                        : Container(),
                                  ],
                                ),
                                sizeVer(10),
                                _buildIconsGridView(context),
                                sizeVer(20),
                                Row(
                                  children: [
                                    const Text(
                                      "Color:",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    _isErrorColor
                                        ? Text(
                                            "Please select color",
                                            style: TextStyle(
                                                color: Colors.red.shade900),
                                          )
                                        : Container(),
                                  ],
                                ),
                                sizeVer(10),
                                SingleChildScrollView(
                                    controller: _colorController,
                                    scrollDirection: Axis.horizontal,
                                    child: _buildColor(
                                        mainColorsState.mainColors)),
                                sizeVer(20),
                                _isUpdatePage && _account!.id != "main"
                                    ? TextButton.icon(
                                        onPressed: () {
                                          _buildShowDialog(context);
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.trashCan,
                                          color: Colors.red.shade900,
                                        ),
                                        label: Text(
                                          "Delete",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Colors.red.shade900),
                                        ))
                                    : Container(),
                                _isUpdatePage
                                    ? Container()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Select currency:",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          PullDownButton(
                                            itemBuilder: (context) {
                                              return currencies
                                                  .map((currency) =>
                                                      PullDownMenuItem
                                                          .selectable(
                                                              onTap: () {
                                                                setState(() {
                                                                  _currency =
                                                                      currency;
                                                                });
                                                              },
                                                              title: currency
                                                                  .code))
                                                  .toList();
                                            },
                                            buttonBuilder: (context, showMenu) {
                                              return TextButton(
                                                  onPressed: showMenu,
                                                  child: Text(
                                                    _currency.code,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ));
                                            },
                                          ),
                                        ],
                                      ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyButtonWidget(
                                        title: _isUpdatePage ? 'Save' : 'Add',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        borderRadius: BorderRadius.circular(30),
                                        paddingVertical: 15,
                                        onTap: _buildCRUDAccount),
                                  ],
                                ),
                                sizeVer(20),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want to delete?"),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        accountBloc.add(DeleteAccount(id: _account!.id));

                        Navigator.pop(context);
                        Navigator.pop(context);
                        selectedIconCubit.changeIcon(null);
                        selectedColorCubit.changeColor(null);
                      },
                      child: Text(
                        "Yes",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.red.shade900),
                      )),
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "No",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.grey),
                      )),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Row _buildColor(List<Color> mainColors) {
    return Row(
      children: [
        ...List.generate(
          mainColors.length,
          (index) {
            var selectedColor = mainColors[index];
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isErrorColor = false;
                  });
                  context.read<SelectedColorCubit>().changeColor(selectedColor);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: _color == selectedColor ? _color : null,
                      shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundColor: mainColors[index],
                    child: _color == selectedColor
                        ? const Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                          )
                        : Container(),
                  ),
                ),
              ),
            );
          },
        ),
        GestureDetector(
          onTap: () {
            context.read<SelectedColorCubit>().changeColor(null);
            setState(() {
              _colorController.jumpTo(0);
            });

            Navigator.pushNamed(context, PageConst.colorsPage);
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 5, right: 10),
            child: CircleAvatar(
              backgroundColor: secondaryColor,
              child: Icon(
                FontAwesomeIcons.plus,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  GridView _buildIconsGridView(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      crossAxisCount: 4,
      children: <Widget>[
        ...List.generate(accountIcons.length, (index) {
          var selectedIconData = accountIcons[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _isErrorIcon = false;
              });
              context.read<SelectedIconCubit>().changeIcon(selectedIconData);
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _iconData == selectedIconData ? _color : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor:
                    _iconData == selectedIconData ? _color : secondaryColor,
                child: Icon(
                  accountIcons[index],
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ],
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
              focusNode: _amountFocusNode,
              controller: _amountController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter\nvalid amount.";
                }
                return null;
              },
              onSaved: (newValue) {
                _balance = double.parse(newValue!);
              },
              maxLength: 12,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              maxLines: 1,
              textAlign: TextAlign.center,
              showCursor: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,4}$'))
              ],
              decoration: const InputDecoration(
                counterText: "",
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
                _currency.code,
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

  void _buildCRUDAccount() {
    if (_iconData == null) {
      setState(() {
        _isErrorIcon = true;
      });
    }
    if (_color == null) {
      setState(() {
        _isErrorColor = true;
      });
    }

    if (_formKey.currentState!.validate() &&
        _color != null &&
        _iconData != null) {
      _formKey.currentState!.save();
      final String accountId = _isUpdatePage ? _account!.id : sl<Uuid>().v1();
      final List<TransactionEntity> transactionHistory =
          _isUpdatePage ? _account!.transactionHistory : [];
      final bool isPrimary = _isUpdatePage ? true : false;
      final DateTime openingDate =
          accountId == "main" ? _account!.openingDate : DateTime.now();
      final currency = _isUpdatePage ? _account!.currency : _currency;
      final accountEntity = AccountEntity(
          id: accountId,
          name: _accountName,
          iconData: _iconData!,
          color: _color!,
          type: AccountType.cash,
          balance: _balance,
          currency: currency,
          isPrimary: isPrimary,
          isActive: true,
          ownershipType: OwnershipType.individual,
          openingDate: openingDate,
          transactionHistory: transactionHistory);
      _isUpdatePage
          ? accountBloc.add(UpdateAccount(accountEntity: accountEntity))
          : accountBloc.add(CreateAccount(accountEntity: accountEntity));
      Navigator.pop(context);
      selectedIconCubit.changeIcon(null);
      selectedColorCubit.changeColor(null);
    }
  }
}
