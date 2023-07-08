import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../constants/period_enum.dart';

part 'selected_date_state.dart';

class SelectedDateCubit extends Cubit<DateTime> {
  SelectedDateCubit() : super(DateTime.now());

  void changeDate(DateTime selectedDate) {
    emit(selectedDate);
  }

  void moveForward(Period currentPeriod) {
    
    DateTime now = DateTime.now();
    switch (currentPeriod) {
      case Period.day:
        DateTime selectedDate = state.add(const Duration(days: 1));
        if (selectedDate.isBefore(now)) {
          emit(selectedDate);
        }
        break;
      case Period.week:
        DateTime selectedDate =
            state.subtract(Duration(days: state.weekday - 1));
        selectedDate = selectedDate.add(const Duration(days: 7));
        if (selectedDate.isBefore(now)) {
          emit(selectedDate);
        }
        break;
      case Period.month:
        DateTime selectedDate = DateTime(state.year, state.month + 1);
        if (selectedDate.isBefore(now)) {
          emit(selectedDate);
        }
        break;
      case Period.year:
        DateTime selectedDate = DateTime(state.year+1, now.month);
        if (selectedDate.isBefore(now)) {
          emit(selectedDate);
        }
        break;
      case Period.period:
        // DateTime selectedDate = state.add(const Duration(days: 1));
        // if (selectedDate.isBefore(now)) {
        //   emit(selectedDate);
        // }
        break;
      // default:
      //   Period.day;
    }
  }

  void moveBackward(Period currentPeriod) {
    DateTime now = DateTime.now();
    switch (currentPeriod) {
      case Period.day:
        DateTime selectedDate = state.subtract(const Duration(days: 1));
        if (selectedDate.isBefore(now)) {
          emit(selectedDate);
        }
        break;
      case Period.week:
        DateTime selectedDate =
            state.subtract(Duration(days: state.weekday - 1));
        selectedDate = selectedDate.subtract(const Duration(days: 7));

        if (selectedDate.isBefore(now)) {
          emit(selectedDate);
        }
        break;
      case Period.month:
        DateTime selectedDate = DateTime(state.year, state.month - 1);
        if (selectedDate.isBefore(now)) {
          emit(selectedDate);
        }
        break;
      case Period.year:
        DateTime selectedDate = DateTime(state.year - 1);
        if (selectedDate.isBefore(now)) {
          emit(selectedDate);
        }
        break;
      case Period.period:
        // DateTime selectedDate = state.add(const Duration(days: 1));
        // if (selectedDate.isBefore(now)) {
        //   emit(selectedDate);
        // }
        break;
      default:
        Period.day;
    }
  }
}
