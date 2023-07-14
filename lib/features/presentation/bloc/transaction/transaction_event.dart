part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class AddTransaction extends TransactionEvent {
  final TransactionEntity transaction;
  final AccountEntity account;
  const AddTransaction({
    required this.transaction,
    required this.account,
  });

  @override
  List<Object> get props => [
        transaction,
        account,
      ];
}

class UpdateTransaction extends TransactionEvent {
  final TransactionEntity transaction;
    final AccountEntity account;

  const UpdateTransaction({
    required this.transaction,
    required this.account,
  });

  @override
  List<Object> get props => [
        transaction,
        account,
      ];
}

class GetTransactions extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class DeleteTransaction extends TransactionEvent {
  final AccountEntity account;
  final TransactionEntity transaction;
  const DeleteTransaction({
    required this.transaction,
    required this.account,
  });

  @override
  List<Object> get props => [transaction, account];
}
