part of 'main_colors_cubit.dart';

abstract class MainColorsState extends Equatable {
  const MainColorsState();

  @override
  List<Object> get props => [];
}

class MainColorsInitial extends MainColorsState {}

class MainColorsLoaded extends MainColorsState {
  final List<Color> mainColors;
  const MainColorsLoaded({
    required this.mainColors,
  });

  @override
  List<Object> get props => [mainColors];
}
