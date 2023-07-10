import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class SelectedColorCubit extends Cubit<Color?> {
  SelectedColorCubit() : super(null);

  void changeColor(Color? color) {
    emit(color);
  }

 
}
