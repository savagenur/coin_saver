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

// class AddTransaction extends AccountEvent {
//   final AccountEntity accountEntity;
//   final TransactionEntity transactionEntity;
//   final bool isIncome;
//   final double amount;
//   const AddTransaction({
//     required this.accountEntity,
//     required this.transactionEntity,
//     required this.isIncome,
//     required this.amount,
//   });
//   @override
//   List<Object> get props => [
//         accountEntity,
//         transactionEntity,
//         isIncome,
//         amount,
//       ];
// }

// class DeleteTransaction extends AccountEvent {
//   final AccountEntity accountEntity;
//   final TransactionEntity transactionEntity;
//   const DeleteTransaction({
//     required this.accountEntity,
//     required this.transactionEntity,
//   });
//   @override
//   List<Object> get props => [
//         accountEntity,
//         transactionEntity,
//       ];
// }
