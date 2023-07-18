part of 'home_time_period_bloc.dart';

abstract class HomeTimePeriodEvent extends Equatable {
  const HomeTimePeriodEvent();

  @override
  List<Object> get props => [];
}

class SetDayPeriod extends HomeTimePeriodEvent {
  final DateTime selectedDate;

  const SetDayPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}

class GetTodayPeriod extends HomeTimePeriodEvent {
  @override
  List<Object> get props => [];
}

class SetWeekPeriod extends HomeTimePeriodEvent {
  final DateTime selectedDate;

  const SetWeekPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}

class SetMonthPeriod extends HomeTimePeriodEvent {
  final DateTime selectedDate;

  const SetMonthPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}

class SetYearPeriod extends HomeTimePeriodEvent {
  final DateTime selectedDate;

  const SetYearPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}

class SetPeriod extends HomeTimePeriodEvent {
  final DateTime selectedStart;
  final DateTime selectedEnd;

  const SetPeriod({
    required this.selectedStart,
    required this.selectedEnd,
  });
  @override
  List<Object> get props => [
        selectedStart,
        selectedEnd,
      ];
}
