part of 'main_time_period_bloc.dart';

abstract class MainTimePeriodEvent extends Equatable {
  const MainTimePeriodEvent();

  @override
  List<Object> get props => [];
}

class SetDayPeriod extends MainTimePeriodEvent {
  final DateTime selectedDate;

  const SetDayPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}

class GetTodayPeriod extends MainTimePeriodEvent {
  @override
  List<Object> get props => [];
}

class SetWeekPeriod extends MainTimePeriodEvent {
  final DateTime selectedDate;

  const SetWeekPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}

class SetMonthPeriod extends MainTimePeriodEvent {
  final DateTime selectedDate;

  const SetMonthPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}

class SetYearPeriod extends MainTimePeriodEvent {
  final DateTime selectedDate;

  const SetYearPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}
