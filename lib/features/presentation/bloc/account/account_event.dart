part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class GetAccounts extends AccountEvent {
  const GetAccounts();

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

