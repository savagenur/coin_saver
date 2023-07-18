import 'package:coin_saver/constants/category_icons.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/presentation/bloc/category/category_bloc.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/main_colors/main_colors_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_category/selected_category_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_color/selected_color_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_date/selected_date_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_icon/selected_icon_cubit.dart';
import 'package:coin_saver/features/presentation/pages/add_transaction/add_transaction_page.dart';
import 'package:coin_saver/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../bloc/account/account_bloc.dart';
import '../../widgets/my_button_widget.dart';

class CreateCategoryPage extends StatefulWidget {
  final bool isIncome;
  const CreateCategoryPage({super.key, required this.isIncome});

  @override
  State<CreateCategoryPage> createState() => CreateCategoryPageState();
}

class CreateCategoryPageState extends State<CreateCategoryPage> {
  late TransactionType _selectedTransactionType;
  late bool _isIncome;
  late AccountEntity _account;
  late DateTime _selectedDate;
  IconData? _iconData;
  Color? _color;
  String _title = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late ScrollController _colorController;
  late SelectedIconCubit selectedIconCubit;
  late SelectedColorCubit selectedColorCubit;
  CategoryEntity? _category;
  @override
  void initState() {
    super.initState();

    selectedIconCubit = context.read<SelectedIconCubit>();
    selectedColorCubit = context.read<SelectedColorCubit>();
    _isIncome = widget.isIncome;
    _selectedTransactionType = setTransactionType(widget.isIncome);
    _colorController = ScrollController();
  }

  TransactionType setTransactionType(bool isIncome) {
    return isIncome ? TransactionType.income : TransactionType.expense;
  }

  bool isErrorIcon = false;
  bool isErrorColor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              selectedIconCubit.changeIcon(null);
              selectedColorCubit.changeColor(null);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Create Category"),
      ),
      body: Form(
        key: _formKey,
        child: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accountState) {
            if (accountState is AccountLoaded) {
              return BlocBuilder<SelectedDateCubit, DateRange>(
                builder: (context, dateRange) {
                  _account = accountState.accounts.firstWhere(
                    (element) => element.isPrimary,
                    orElse: () => accountError,
                  );
                  _selectedDate = dateRange.startDate;
                  return BlocBuilder<SelectedIconCubit, IconData?>(
                    builder: (context, selectedIcon) {
                      _iconData = selectedIcon;
                      return BlocBuilder<SelectedColorCubit, Color?>(
                        builder: (context, selectedColor) {
                          _color = selectedColor;
                          return BlocBuilder<MainColorsCubit, MainColorsState>(
                            builder: (context, mainColorsState) {
                              if (mainColorsState is MainColorsLoaded) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  _color ?? secondaryColor,
                                              child: Icon(
                                                _iconData ??
                                                    Icons.question_mark_sharp,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          sizeHor(10),
                                          Expanded(
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "Please enter category";
                                                }
                                                return null;
                                              },
                                              onSaved: (newValue) {
                                                _title = newValue!;
                                              },
                                              decoration: const InputDecoration(
                                                hintText: "Category Name",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Listener(
                                        onPointerDown: (_) {
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Divider(),
                                                _buildIsIncomeRadio(context),
                                                const Divider(),
                                                Text(
                                                  "Planned outlay",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                sizeVer(10),
                                                _buildPlannedOutlay(context),
                                                sizeVer(20),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Icons",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade600),
                                                    ),
                                                    sizeHor(10),
                                                    isErrorIcon
                                                        ? Text(
                                                            "Please select icon.",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red
                                                                    .shade800),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                                sizeVer(10),
                                                _buildGridView(context),
                                                sizeVer(10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Colors",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade600),
                                                    ),
                                                    sizeHor(10),
                                                    isErrorColor
                                                        ? Text(
                                                            "Please select icon.",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red
                                                                    .shade800),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                                sizeVer(10),
                                                SingleChildScrollView(
                                                    controller:
                                                        _colorController,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: _buildColor(
                                                        mainColorsState
                                                            .mainColors)),
                                                sizeVer(20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    MyButtonWidget(
                                                        title: 'Add',
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .5,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        paddingVertical: 15,
                                                        onTap:
                                                            _buildCreateCategory),
                                                  ],
                                                ),
                                                sizeVer(30),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            }
            return const Scaffold();
          },
        ),
      ),
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
                    isErrorColor = false;
                  });
                  selectedColorCubit.changeColor(selectedColor);
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
            selectedColorCubit.changeColor(null);
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
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  GridView _buildGridView(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      crossAxisCount: 4,
      children: <Widget>[
        ...List.generate(mainIcons.length, (index) {
          var selectedIconData = mainIcons[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                isErrorIcon = false;
              });
              selectedIconCubit.changeIcon(selectedIconData);
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
                  mainIcons[index],
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PageConst.catalogIconsPage);
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Row _buildPlannedOutlay(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .3,
            child: const TextField(
              enabled: false,
              decoration: InputDecoration(hintText: "Not selected"),
            ),
          ),
        ),
        sizeHor(10),
        const Expanded(
            child: Text(
          "KGS per month",
          style: TextStyle(fontWeight: FontWeight.w500),
        ))
      ],
    );
  }

  Row _buildIsIncomeRadio(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: RadioListTile(
            value: TransactionType.expense,
            groupValue: _selectedTransactionType,
            onChanged: (value) {
              setState(() {
                _selectedTransactionType = value!;
                _isIncome = false;
              });
            },
            title: Text(
              "Expense",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        Expanded(
          child: RadioListTile(
            value: TransactionType.income,
            groupValue: _selectedTransactionType,
            onChanged: (value) {
              setState(() {
                _selectedTransactionType = value!;
                _isIncome = true;
              });
            },
            title: Text(
              "Income",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }

  void _buildCreateCategory() {
    if (_iconData == null) {
      setState(() {
        isErrorIcon = true;
      });
    }
    if (_color == null) {
      setState(() {
        isErrorColor = true;
      });
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _category = CategoryEntity(
        id: sl<Uuid>().v1(),
        name: _title,
        iconData: _iconData!,
        color: _color!,
        isIncome: _isIncome,
        dateTime: DateTime.now(),
      );
      context.read<CategoryBloc>().add(
            CreateCategory(category: _category!),
          );
      context.read<SelectedCategoryCubit>().changeCategory(_category);

      Navigator.pushNamedAndRemoveUntil(
          context,
          PageConst.addTransactionPage,
          arguments: AddTransactionPage(
            isIncome: _isIncome,
            account: _account,
            selectedDate: _selectedDate,
            category: _category,
          ),
          (route) => route.settings.name == PageConst.addTransactionPage);

      selectedIconCubit.changeIcon(null);
      selectedColorCubit.changeColor(null);
      context.read<SelectedCategoryCubit>().changeCategory(_category);
    }
  }
}

enum TransactionType {
  expense,
  income,
}
