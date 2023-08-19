import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/main_colors/main_colors_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_color/selected_color_cubit.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants/colors.dart';

class ColorsPage extends StatefulWidget {
  const ColorsPage({super.key});

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  Color? _selectedColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              // context.read<SelectedColorCubit>().changeColor(null);
            },
            icon: const Icon(FontAwesomeIcons.arrowLeft)),
        title: Text(AppLocalizations.of(context)!.color),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.selectedColor,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                sizeHor(10),
                CircleAvatar(
                  backgroundColor: _selectedColor,
                  child: _selectedColor == null
                      ? const Icon(FontAwesomeIcons.question)
                      : Container(),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: colors.length,
                itemBuilder: (BuildContext context, int index) {
                  var primaryColor = colors[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = primaryColor;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: colors[index],
                      child: _selectedColor == primaryColor
                          ? const Icon(
                              FontAwesomeIcons.check,
                              color: Colors.white,
                            )
                          : Container(),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(),
          MyButtonWidget(
            title: AppLocalizations.of(context)!.addColor,
            borderRadius: BorderRadius.circular(20),
            width: MediaQuery.of(context).size.width * .8,
            onTap: _selectedColor != null
                ? () {
                    context
                        .read<SelectedColorCubit>()
                        .changeColor(_selectedColor);
                    context
                        .read<MainColorsCubit>()
                        .addMainColor(_selectedColor!);

                    Navigator.pop(context);
                  }
                : null,
            paddingVertical: 15,
          )
        ],
      ),
    );
  }
}
