part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();


}

class AccountInitial extends AccountState {
  @override
  List<Object> get props => [];
}

class AccountLoading extends AccountState {
  @override
  List<Object> get props => [];
}

class AccountLoaded extends AccountState {
  final List<AccountEntity> accounts;
  const AccountLoaded({
    required this.accounts,
  });
  @override
  List<Object> get props => [
    accounts,
  ];
}

class AccountFailure extends AccountState {
  @override
  List<Object> get props => [];
}
