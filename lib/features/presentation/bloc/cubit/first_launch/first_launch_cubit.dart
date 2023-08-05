import 'package:bloc/bloc.dart';

import 'package:coin_saver/features/domain/usecases/hive/get_first_launch_usecase.dart';

class FirstLaunchCubit extends Cubit<FirstLaunch> {
  final GetFirstLaunchUsecase getFirstLaunchUsecase;
  FirstLaunchCubit({
    required this.getFirstLaunchUsecase,
  }) : super(FirstLaunch(isSplashShowed: false));
  void changeIsFirstLaunch(bool? newValue) {
    emit(FirstLaunch(
        isFirstLaunch: newValue, isSplashShowed: state.isSplashShowed));
  }

  void changeIsSplashShowed(bool? newValue) {
    print("object");

    emit(FirstLaunch(
        isFirstLaunch: state.isFirstLaunch, isSplashShowed: newValue));
    print(state.isSplashShowed);
  }

  void getFirstLaunch() {
    final bool isFirstLaunch = getFirstLaunchUsecase.call();
    emit(FirstLaunch(
        isFirstLaunch: isFirstLaunch, isSplashShowed: state.isSplashShowed));
  }
}

class FirstLaunch {
  final bool? isFirstLaunch;
  final bool? isSplashShowed;
  FirstLaunch({
    this.isFirstLaunch,
    this.isSplashShowed,
  });
}
