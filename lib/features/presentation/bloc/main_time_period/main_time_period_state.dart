part of 'main_time_period_bloc.dart';

// For MainTransactionEntity
class MainTimePeriodState extends Equatable {
  final DateTime selectedPeriod;
  final List<MainTransactionEntity> transactions;
  const MainTimePeriodState(
      {required this.selectedPeriod, required this.transactions});

  @override
  List<Object> get props => [
        selectedPeriod,
        transactions,
      ];
}


