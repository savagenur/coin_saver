import 'package:bloc/bloc.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'main_colors_state.dart';

class MainColorsCubit extends Cubit<MainColorsState> {
  MainColorsCubit() : super(MainColorsInitial());

  Future<void> getMainColors() async {
    Box box = await Hive.openBox<Color>(BoxConst.colors);
    List<Color> mainColors = box.values.toList() as List<Color>;
    emit(MainColorsLoaded(mainColors: mainColors));
  }

  Future<void> addMainColor(Color color) async {
      Box box = await Hive.openBox<Color>(BoxConst.colors);
    List<Color> oldColors = box.values.toList() as List<Color>;
    List<Color> mainColors = oldColors;
    if (!oldColors.contains(color)) {
      mainColors = [
        ...oldColors
          ..removeLast()
          ..insert(0, color)
      ];
      await box.clear();
      await box.addAll(mainColors);
    }

    emit(MainColorsLoaded(mainColors: mainColors));
  }
}
