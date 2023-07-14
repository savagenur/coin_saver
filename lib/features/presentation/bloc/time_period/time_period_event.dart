part of 'time_period_bloc.dart';

abstract class TimePeriodEvent extends Equatable {
  const TimePeriodEvent();

  @override
  List<Object> get props => [];
}

class SetDayPeriod extends TimePeriodEvent {
  final DateTime selectedDate;

  const SetDayPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}

class GetTodayPeriod extends TimePeriodEvent {
  @override
  List<Object> get props => [];
}

class SetWeekPeriod extends TimePeriodEvent {
  final DateTime selectedDate;

  const SetWeekPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}

class SetMonthPeriod extends TimePeriodEvent {
  final DateTime selectedDate;

  const SetMonthPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}

class SetYearPeriod extends TimePeriodEvent {
  final DateTime selectedDate;

  const SetYearPeriod({
    required this.selectedDate,
  });
  @override
  List<Object> get props => [
        selectedDate,
      ];
}
