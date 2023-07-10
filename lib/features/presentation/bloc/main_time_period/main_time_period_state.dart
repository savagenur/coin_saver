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
  final DateTime selectedDate;
  final List<MainTransactionEntity> transactions;
  const MainTimePeriodLoaded({
    required this.selectedDate,
    required this.transactions,
  });
  @override
  List<Object> get props => [
        selectedDate,
        transactions,
      ];
}

class MainTimePeriodLoading extends MainTimePeriodState {
  @override
  List<Object> get props => [];
}
