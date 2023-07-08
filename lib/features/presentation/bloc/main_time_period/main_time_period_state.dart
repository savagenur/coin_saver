part of 'main_time_period_bloc.dart';

// For MainTransactionEntity
abstract class MainTimePeriodState extends Equatable {
  const MainTimePeriodState();

  @override
  List<Object> get props => [
        // selectedPeriod,
        // transactions,
      ];
}

class MainTimePeriodLoaded extends MainTimePeriodState {
  final DateTime selectedPeriod;
  final List<MainTransactionEntity> transactions;
  const MainTimePeriodLoaded({
    required this.selectedPeriod,
    required this.transactions,
  });
  @override
  List<Object> get props => [
        selectedPeriod,
        transactions,
      ];
}

class MainTimePeriodLoading extends MainTimePeriodState {
  @override
  List<Object> get props => [];
}
