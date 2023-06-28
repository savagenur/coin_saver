import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/constants/main_categories.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:flutter/material.dart';

class AddCategoryPage extends StatefulWidget {
  final bool isIncome;
  const AddCategoryPage({super.key, required this.isIncome});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  late List<CategoryEntity> categories;
  @override
  void initState() {
    super.initState();
    categories = getMainCategoriesList();
  }

  List<CategoryEntity> getMainCategoriesList() {
    return mainCategories
        .where((category) => category.isIncome == widget.isIncome)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: GridView.count(
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          crossAxisCount: 4,
          children: <Widget>[
            ...List.generate(categories.length, (index) {
              CategoryEntity categoryEntity = categories[index];
              return Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: categoryEntity.color,
                      child: Icon(
                        categoryEntity.iconData,
                        color: Colors.white,
                      ),
                    ),
                    sizeVer(5),
                    Text(
                      categoryEntity.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, PageConst.createCategoryPage);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: secondaryColor,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  Text("Create"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
