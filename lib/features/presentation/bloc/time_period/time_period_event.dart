part of 'time_period_bloc.dart';

abstract class TimePeriodEvent extends Equatable {
  const TimePeriodEvent();

  @override
  List<Object> get props => [];
}

class SetDayPeriod extends TimePeriodEvent {
  final DateTime selectedDate;
  final List<TransactionEntity> transactions;

  const SetDayPeriod({
    required this.selectedDate,
    required this.transactions,
  });
  @override
  List<Object> get props => [
        selectedDate,
        transactions,
      ];
}

class SetWeekPeriod extends TimePeriodEvent {
  final DateTime selectedDate;
  final List<TransactionEntity> transactions;

  const SetWeekPeriod({
    required this.selectedDate,
    required this.transactions,
  });
  @override
  List<Object> get props => [
        selectedDate,
        transactions,
      ];
}

class SetMonthPeriod extends TimePeriodEvent {
  final DateTime selectedDate;
  final List<TransactionEntity> transactions;

  const SetMonthPeriod({
    required this.selectedDate,
    required this.transactions,
  });
  @override
  List<Object> get props => [
        selectedDate,
        transactions,
      ];
}

class SetYearPeriod extends TimePeriodEvent {
  final DateTime selectedDate;
  final List<TransactionEntity> transactions;

  const SetYearPeriod({
    required this.selectedDate,
    required this.transactions,
  });
  @override
  List<Object> get props => [
        selectedDate,
        transactions,
      ];
}
