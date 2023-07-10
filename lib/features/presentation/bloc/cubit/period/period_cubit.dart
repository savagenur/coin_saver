import 'package:bloc/bloc.dart';
import 'package:coin_saver/constants/period_enum.dart';


class PeriodCubit extends Cubit<Period> {
  PeriodCubit() : super(Period.day);

  void changePeriod(Period newPeriod) {
    emit(newPeriod);
  }
}
