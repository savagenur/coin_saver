import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:coin_saver/features/domain/usecases/account/create_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/delete_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/get_accounts_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/select_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/update_account_usecase.dart';

import '../../../domain/entities/account/account_entity.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final CreateAccountUsecase createAccountUsecase;
  final GetAccountsUsecase getAccountsUsecase;
  final UpdateAccountUsecase updateAccountUsecase;
  final DeleteAccountUsecase deleteAccountUsecase;
  final SelectAccountUsecase selectAccountUsecase;
  AccountBloc({
    required this.createAccountUsecase,
    required this.getAccountsUsecase,
    required this.updateAccountUsecase,
    required this.deleteAccountUsecase,
    required this.selectAccountUsecase,
  }) : super(AccountInitial()) {
    on<CreateAccount>(_onCreateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<SelectAccount>(_onSelectAccount);
    on<GetAccounts>(_onGetAccounts);
  }

  FutureOr<void> _onCreateAccount(
      CreateAccount event, Emitter<AccountState> emit) async {
    await createAccountUsecase.call(event.accountEntity);
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onDeleteAccount(
      DeleteAccount event, Emitter<AccountState> emit) async {
    await deleteAccountUsecase.call(event.id);
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onUpdateAccount(
      UpdateAccount event, Emitter<AccountState> emit) async {
    await updateAccountUsecase.call(event.accountEntity);
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onGetAccounts(
      GetAccounts event, Emitter<AccountState> emit) async {
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onSelectAccount(
      SelectAccount event, Emitter<AccountState> emit) async {
    await selectAccountUsecase.call(event.accountEntity, event.accounts);
    final accounts = await getAccountsUsecase.call();

    emit(AccountLoaded(accounts: accounts));
  }
}
