part of 'transaction_bloc.dart';

class TransactionState extends Equatable {
  final List<TransactionEntity> transactions;
  const TransactionState(
    {
      required this.transactions,
    }
  );

  @override
  List<Object> get props => [
    transactions,
  ];
}
