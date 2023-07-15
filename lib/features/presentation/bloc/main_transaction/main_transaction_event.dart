part of 'main_transaction_bloc.dart';

abstract class MainTransactionEvent extends Equatable {
  const MainTransactionEvent();

  @override
  List<Object> get props => [];
}

class AddTransaction extends MainTransactionEvent {
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

class UpdateTransaction extends MainTransactionEvent {
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

class GetTransactions extends MainTransactionEvent {
  @override
  List<Object> get props => [];
}

class DeleteTransaction extends MainTransactionEvent {
  final AccountEntity account;
  final TransactionEntity transaction;
  const DeleteTransaction({
    required this.transaction,
    required this.account,
  });

  @override
  List<Object> get props => [transaction, account];
}
