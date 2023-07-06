part of 'time_period_bloc.dart';

// For TransactionEntity
 class TimePeriodState extends Equatable {
  final DateTime selectedPeriod;
  final List<TransactionEntity> transactions;
  const TimePeriodState(
      {required this.selectedPeriod, required this.transactions});

  @override
  List<Object> get props => [
        selectedPeriod,
        transactions,
      ];
}
