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

class SelectAccount extends AccountEvent {
  final AccountEntity accountEntity;
  final List<AccountEntity> accounts;
  const SelectAccount({
    required this.accountEntity,
    required this.accounts,
  });
  @override
  List<Object> get props => [
        accountEntity,
        accounts,
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
