part of 'home_time_period_bloc.dart';

// For TransactionEntity
abstract class HomeTimePeriodState extends Equatable {
  const HomeTimePeriodState();

  @override
  List<Object> get props => [
        // selectedPeriod,
        // transactions,
      ];
}

class HomeTimePeriodLoaded extends HomeTimePeriodState {
  final DateTime selectedDate;
  final List<TransactionEntity> transactions;
  const HomeTimePeriodLoaded({
    required this.selectedDate,
    required this.transactions,
  });
  @override
  List<Object> get props => [
        selectedDate,
        transactions,
      ];
}

class HomeTimePeriodLoading extends HomeTimePeriodState {
  @override
  List<Object> get props => [];
}
