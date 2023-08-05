import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/presentation/pages/create_category/create_category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/category/category_bloc.dart';
import '../../bloc/cubit/selected_category/selected_category_cubit.dart';

class AddCategoryPage extends StatefulWidget {
  final bool isIncome;

  const AddCategoryPage({
    super.key,
    required this.isIncome,
  });

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  List<CategoryEntity> _categories = [];
  late bool _isIncome;
  late CategoryEntity? _category;

  // Blocs
  late SelectedCategoryCubit selectedCategoryCubit;
  late CategoryBloc categoryBloc;
  @override
  void initState() {
    selectedCategoryCubit = context.read<SelectedCategoryCubit>();
    categoryBloc = context.read<CategoryBloc>();
    _isIncome = widget.isIncome;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(FontAwesomeIcons.arrowLeft)),
        title:  Text(AppLocalizations.of(context)!.addCategory),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, categoryState) {
          if (categoryState is CategoryLoaded) {
            _categories = categoryState.categories
                .where((category) => category.isIncome == _isIncome)
                .toList()
              ..sort(
                (a, b) => b.dateTime.compareTo(a.dateTime),
              );
            return BlocBuilder<SelectedCategoryCubit, CategoryEntity?>(
              builder: (context, selectedCategory) {
                _category = selectedCategory;
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
                          child:  Column(
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
                        CategoryEntity categoryEntity = _categories[index];

                        return GestureDetector(
                          onTap: () {
                            selectedCategoryCubit
                                .changeCategory(categoryEntity);
                            categoryBloc.add(UpdateCategory(
                                category: categoryEntity.copyWith(
                                    dateTime: DateTime.now())));
                            Navigator.pop(context);
                          },
                          child: _category != null &&
                                  _category!.id == categoryEntity.id
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
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
