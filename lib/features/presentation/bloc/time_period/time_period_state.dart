part of 'time_period_bloc.dart';

// For TransactionEntity
abstract class TimePeriodState extends Equatable {
  const TimePeriodState();

  @override
  List<Object> get props => [
        // selectedPeriod,
        // transactions,
      ];
}

class TimePeriodLoaded extends TimePeriodState {
  final DateTime selectedDate;
  final List<TransactionEntity> transactions;
  const TimePeriodLoaded({
    required this.selectedDate,
    required this.transactions,
  });
  @override
  List<Object> get props => [
        selectedDate,
        transactions,
      ];
}

class TimePeriodLoading extends TimePeriodState {
  @override
  List<Object> get props => [];
}
