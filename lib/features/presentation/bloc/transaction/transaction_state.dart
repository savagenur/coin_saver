part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionLoading extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;
  const TransactionLoaded({
    required this.transactions,
  });
  @override
  List<Object> get props => [
        transactions,
      ];
}

class TransactionFailure extends TransactionState {
  @override
  List<Object> get props => [];
}
