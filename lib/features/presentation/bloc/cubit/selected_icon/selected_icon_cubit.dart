import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class SelectedIconCubit extends Cubit<IconData?> {
  SelectedIconCubit() : super(null);

  void changeIcon(IconData? iconData) {
    emit(iconData);
  }
}
