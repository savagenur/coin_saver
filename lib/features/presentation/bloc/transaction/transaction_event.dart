part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class GetTransactions extends TransactionEvent {
  const GetTransactions();
  @override
  List<Object> get props => [];
}

class AddTransfer extends TransactionEvent {
  final AccountEntity accountFrom;
  final AccountEntity accountTo;
  final TransactionEntity transactionEntity;

  const AddTransfer({
    required this.accountFrom,
    required this.accountTo,
    required this.transactionEntity,
  });
  @override
  List<Object> get props => [
        accountFrom,
        accountTo,
        transactionEntity,
      ];
}

class DeleteTransfer extends TransactionEvent {
  final AccountEntity accountFrom;
  final AccountEntity accountTo;
  final TransactionEntity transactionEntity;

  const DeleteTransfer({
    required this.accountFrom,
    required this.accountTo,
    required this.transactionEntity,
  });
  @override
  List<Object> get props => [
        accountFrom,
        accountTo,
        transactionEntity,
      ];
}

class UpdateTransfer extends TransactionEvent {
  final AccountEntity accountFrom;
  final AccountEntity accountTo;
  final AccountEntity oldAccountTo;
  final AccountEntity oldAccountFrom;
  final TransactionEntity transactionEntity;

  const UpdateTransfer({
    required this.accountFrom,
    required this.accountTo,
    required this.transactionEntity,
    required this.oldAccountTo,
    required this.oldAccountFrom,
  });
  @override
  List<Object> get props => [
        accountFrom,
        accountTo,
        oldAccountTo,
        oldAccountFrom,
        transactionEntity,
      ];
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
