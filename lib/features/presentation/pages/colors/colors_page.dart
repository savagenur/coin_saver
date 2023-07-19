import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/main_colors/main_colors_cubit.dart';
import 'package:coin_saver/features/presentation/bloc/cubit/selected_color/selected_color_cubit.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants/colors.dart';

class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SelectedColorCubit>().changeColor(null);
            },
            icon: const Icon(FontAwesomeIcons.arrowLeft)),
        title: const Text("Colors"),
      ),
      body: BlocBuilder<SelectedColorCubit, Color?>(
        builder: (context, selectedColor) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                ),
                child: Row(
                  children: [
                    Text(
                      "Selected Color:",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                    sizeHor(10),
                    CircleAvatar(
                      backgroundColor: selectedColor,
                      child: selectedColor == null
                          ? const Icon(FontAwesomeIcons.question)
                          : Container(),
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: colors.length,
                    itemBuilder: (BuildContext context, int index) {
                      var primaryColor = colors[index];
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<SelectedColorCubit>()
                              .changeColor(primaryColor);
                        },
                        child: CircleAvatar(
                          backgroundColor: colors[index],
                          child: selectedColor == primaryColor
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
              Divider(),
              MyButtonWidget(
                title: "Add Color",
                borderRadius: BorderRadius.circular(20),
                width: MediaQuery.of(context).size.width * .8,
                onTap: selectedColor != null
                    ? () {
                        context
                            .read<MainColorsCubit>()
                            .addMainColor(selectedColor);

                        Navigator.pop(context);
                      }
                    : null,
                paddingVertical: 15,
              )
            ],
          );
        },
      ),
    );
  }
}
