part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class GetAccounts extends AccountEvent {
  @override
  List<Object> get props => [];
}

class CreateAccount extends AccountEvent {
  final AccountEntity accountEntity;
  const CreateAccount({
    required this.accountEntity,
  });
  @override
  List<Object> get props => [accountEntity];
}

class UpdateAccount extends AccountEvent {
  final AccountEntity accountEntity;
  const UpdateAccount({
    required this.accountEntity,
  });
  @override
  List<Object> get props => [accountEntity];
}

class SetPrimaryAccount extends AccountEvent {
  final String accountId;
  const SetPrimaryAccount({
    required this.accountId,
  });
  @override
  List<Object> get props => [
        accountId,
      ];
}

class DeleteAccount extends AccountEvent {
  final String id;
  const DeleteAccount({
    required this.id,
  });
  @override
  List<Object> get props => [
        id,
      ];
}

class AddTransfer extends AccountEvent {
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

class DeleteTransfer extends AccountEvent {
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

class UpdateTransfer extends AccountEvent {
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


class AddTransaction extends AccountEvent {
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

class UpdateTransaction extends AccountEvent {
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



class DeleteTransaction extends AccountEvent {
  final AccountEntity account;
  final TransactionEntity transaction;
  const DeleteTransaction({
    required this.transaction,
    required this.account,
  });

  @override
  List<Object> get props => [transaction, account];
}

