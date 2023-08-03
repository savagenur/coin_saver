import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_icon/selected_icon_cubit.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants/category_icons.dart';

class CatalogIconsPage extends StatelessWidget {
  const CatalogIconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(FontAwesomeIcons.arrowLeft)),
        centerTitle: true,
        title:  Text(AppLocalizations.of(context)!.iconCatalog),
      ),
      body: BlocBuilder<SelectedIconCubit, IconData?>(
        builder: (context, selectedIcon) {
          return SingleChildScrollView(
            child: Column(
              children: [
                sizeVer(20),
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
                                          .length, (valueIndex) {
                                    var primaryIcon = categoryIcons[
                                        categoryIcons.keys
                                            .elementAt(keyIndex)]![valueIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        context
                                            .read<SelectedIconCubit>()
                                            .changeIcon(primaryIcon);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: selectedIcon == primaryIcon
                                                ? Theme.of(context).primaryColor
                                                : null),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: selectedIcon ==
                                                  primaryIcon
                                              ? Theme.of(context).primaryColor
                                              : secondaryColor,
                                          child: Icon(
                                            categoryIcons[categoryIcons.keys
                                                .elementAt(
                                                    keyIndex)]![valueIndex],
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                            sizeVer(10)
                          ],
                        )),
                sizeVer(60),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: MyButtonWidget(
        title: AppLocalizations.of(context)!.select,
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          Navigator.pop(context);
        },
        width: MediaQuery.of(context).size.width * .6,
      ),
    );
  }
}
