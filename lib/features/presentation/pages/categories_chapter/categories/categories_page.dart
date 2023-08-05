import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../../constants/constants.dart';
import '../../../bloc/category/category_bloc.dart';
import '../../../widgets/my_drawer.dart';
import '../../create_category/create_category_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isIncome = false;
  List<CategoryEntity> _categories = [];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        
        Navigator.popUntil(context, (route) => route.settings.name==PageConst.homePage);
        return true;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const MyDrawer(),
          appBar: _buildAppBar(),
          body: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, categoryState) {
              if (categoryState is CategoryLoaded) {
                _categories = categoryState.categories
                    .where((category) => category.isIncome == _isIncome)
                    .toList()
                  ..sort(
                    (a, b) => b.dateTime.compareTo(a.dateTime),
                  );
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5),
                    itemCount: _categories.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == _categories.length) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, PageConst.createCategoryPage,
                                arguments: CreateCategoryPage(
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
                                AppLocalizations.of(context)!.create,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        );
                      } else {
                        CategoryEntity category = _categories[index];

                        return PullDownButton(
                          itemBuilder: (context) {
                            return [
                              PullDownMenuItem(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(AppLocalizations.of(context)!
                                          .deleteCategory),
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .allOperationsItContainsWillBe),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      actions: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .no)),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<CategoryBloc>()
                                                        .add(DeleteCategory(
                                                            isIncome: _isIncome,
                                                            categoryId:
                                                                category.id));
                                                    context
                                                        .read<AccountBloc>()
                                                        .add(GetAccounts());
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .yes)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                                title: AppLocalizations.of(context)!.delete,
                                icon: FontAwesomeIcons.trash,
                                iconColor: Theme.of(context).colorScheme.error,
                              ),
                            ];
                          },
                          buttonBuilder: (context, showMenu) {
                            return GestureDetector(
                              onLongPress: category.id == "otherIncome" ||
                                      category.id == "otherExpense"
                                  ? () {}
                                  : showMenu,
                              onTap: () {
                                if (category.id == "otherIncome" ||
                                    category.id == "otherExpense") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Padding(
                                        padding: EdgeInsets.all(30),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .thisIsAServiceCategoryAnd,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.pushNamed(
                                      context, PageConst.createCategoryPage,
                                      arguments: CreateCategoryPage(
                                        isIncome: _isIncome,
                                        isUpdate: true,
                                        category: category,
                                      ));
                                }
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: category.color,
                                    child: Icon(
                                      category.iconData,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    category.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        leading: IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(FontAwesomeIcons.bars)),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.categories),
        bottom: TabBar(
          onTap: (value) {
            switch (value) {
              case 0:
                setState(() {
                  _isIncome = false;
                });
                return;
              case 1:
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
              child: Text(AppLocalizations.of(context)!.expensesUpperCase),
            ),
            Tab(child: Text(AppLocalizations.of(context)!.incomeUpperCase)),
          ],
        ));
  }
}
