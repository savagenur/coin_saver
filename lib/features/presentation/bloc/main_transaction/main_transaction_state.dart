part of 'main_transaction_bloc.dart';

abstract class MainTransactionState extends Equatable {
  const MainTransactionState();

  @override
  List<Object> get props => [];
}

class MainTransactionInitial extends MainTransactionState {
  @override
  List<Object> get props => [];
}

class MainTransactionLoading extends MainTransactionState {
  @override
  List<Object> get props => [];
}

class MainTransactionLoaded extends MainTransactionState {
  final List<TransactionEntity> transactions;
  const MainTransactionLoaded({
    required this.transactions,
  });
  @override
  List<Object> get props => [
        transactions,
      ];
}

class MainTransactionFailure extends MainTransactionState {
  @override
  List<Object> get props => [];
}
