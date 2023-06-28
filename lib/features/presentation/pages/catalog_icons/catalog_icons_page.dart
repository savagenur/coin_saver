import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants/category_icons.dart';

class CatalogIconsPage extends StatelessWidget {
  const CatalogIconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Icon Catalog"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "Selected Icon:",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                  sizeHor(10),
                  CircleAvatar(
                    child: FaIcon(
                      FontAwesomeIcons.question,
                    ),
                  )
                ],
              ),
            ),
            sizeVer(10),
            ...List.generate(
                categoryIcons.length,
                (keyIndex) => Column(
                      children: [
                        Text(
                          categoryIcons.keys.elementAt(keyIndex),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Wrap(
                            runAlignment: WrapAlignment.spaceEvenly,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ...List.generate(
                                  categoryIcons.values
                                      .elementAt(keyIndex)
                                      .length,
                                  (valueIndex) => Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.grey.shade300,
                                          child: FaIcon(
                                            categoryIcons[categoryIcons.keys
                                                .elementAt(
                                                    keyIndex)]![valueIndex],
                                          ),
                                        ),
                                      ))
                            ],
                          ),
                        ),
                        sizeVer(10)
                      ],
                    )),
            sizeVer(60),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: MyButtonWidget(
        title: "Select",
        borderRadius: BorderRadius.circular(50),
        onTap: () {},
        width: MediaQuery.of(context).size.width * .6,
      ),
    );
  }
}
