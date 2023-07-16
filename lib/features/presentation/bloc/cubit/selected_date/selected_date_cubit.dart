import 'package:bloc/bloc.dart';

import '../../../../../constants/period_enum.dart';

class SelectedDateCubit extends Cubit<DateRange> {
  SelectedDateCubit()
      : super(DateRange(
          DateTime.now(),
          DateTime.now(),
        ));

  void changeStartDate(DateTime newStartDate) {
    emit(DateRange(newStartDate, state.endDate));
  }

  void changeEndDate(DateTime newEndDate) {
    emit(DateRange(state.startDate, newEndDate));
  }
  void changeStartEnd(DateTime newStartDate,DateTime newEndDate,) {
    emit(DateRange(newStartDate, newEndDate));
  }

  void moveForward(Period currentPeriod) {
    DateTime now = DateTime.now();
    switch (currentPeriod) {
      case Period.day:
        DateTime selectedDate = state.startDate.add(const Duration(days: 1));
        if (selectedDate.isBefore(now)) {
          emit(DateRange(selectedDate, state.endDate));
        }
        break;
      case Period.week:
        DateTime selectedDate = state.startDate
            .subtract(Duration(days: state.startDate.weekday - 1));
        selectedDate = selectedDate.add(const Duration(days: 7));
        if (selectedDate.isBefore(now)) {
          emit(DateRange(selectedDate, state.endDate));
        }
        break;
      case Period.month:
        DateTime selectedDate =
            DateTime(state.startDate.year, state.startDate.month + 1);
        if (selectedDate.isBefore(now)) {
          emit(DateRange(selectedDate, state.endDate));
        }
        break;
      case Period.year:
        DateTime selectedDate = DateTime(state.startDate.year + 1, now.month);
        if (selectedDate.isBefore(now)) {
          emit(DateRange(selectedDate, state.endDate));
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
        DateTime selectedDate =
            state.startDate.subtract(const Duration(days: 1));
        if (selectedDate.isBefore(now)) {
          emit(DateRange(selectedDate, state.endDate));
        }
        break;
      case Period.week:
        DateTime selectedDate = state.startDate
            .subtract(Duration(days: state.startDate.weekday - 1));
        selectedDate = selectedDate.subtract(const Duration(days: 7));

        if (selectedDate.isBefore(now)) {
          emit(DateRange(selectedDate, state.endDate));
        }
        break;
      case Period.month:
        DateTime selectedDate =
            DateTime(state.startDate.year, state.startDate.month - 1);
        if (selectedDate.isBefore(now)) {
          emit(DateRange(selectedDate, state.endDate));
        }
        break;
      case Period.year:
        DateTime selectedDate = DateTime(state.startDate.year - 1);
        if (selectedDate.isBefore(now)) {
          emit(DateRange(selectedDate, state.endDate));
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

class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange(this.startDate, this.endDate);
}
