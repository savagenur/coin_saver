import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/usecases/transaction/add_transaction_usecase.dart';
import 'package:coin_saver/features/domain/usecases/transaction/add_transfer_usecase.dart';
import 'package:coin_saver/features/domain/usecases/transaction/delete_transaction_usecase.dart';
import 'package:equatable/equatable.dart';

import 'package:coin_saver/features/domain/usecases/account/create_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/delete_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/get_accounts_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/update_account_usecase.dart';

import '../../../domain/entities/account/account_entity.dart';
import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../../domain/usecases/account/set_primary_account_usecase.dart';
import '../../../domain/usecases/transaction/delete_transfer_usecase.dart';
import '../../../domain/usecases/transaction/get_transactions_usecase.dart';
import '../../../domain/usecases/transaction/update_transaction_usecase.dart';
import '../../../domain/usecases/transaction/update_transfer_usecase.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final CreateAccountUsecase createAccountUsecase;
  final GetAccountsUsecase getAccountsUsecase;
  final UpdateAccountUsecase updateAccountUsecase;
  final DeleteAccountUsecase deleteAccountUsecase;
  final SetPrimaryAccountUsecase setPrimaryAccountUsecase;


  AccountBloc({
    required this.createAccountUsecase,
    required this.getAccountsUsecase,
    required this.updateAccountUsecase,
    required this.deleteAccountUsecase,
    required this.setPrimaryAccountUsecase,
  
  }) : super(AccountInitial()) {
    on<CreateAccount>(_onCreateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<SetPrimaryAccount>(_onSetPrimaryAccount);
    on<GetAccounts>(_onGetAccounts);
    

    // Transaction
   
  }

  FutureOr<void> _onCreateAccount(
      CreateAccount event, Emitter<AccountState> emit) async {
    await createAccountUsecase.call(event.accountEntity);
    await setPrimaryAccountUsecase.call(event.accountEntity.id);
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoading());
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onDeleteAccount(
      DeleteAccount event, Emitter<AccountState> emit) async {
    await setPrimaryAccountUsecase.call("main");
    await deleteAccountUsecase.call(event.id);
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoading());
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onUpdateAccount(
      UpdateAccount event, Emitter<AccountState> emit) async {
    await setPrimaryAccountUsecase.call(event.accountEntity.id);
    await updateAccountUsecase.call(event.accountEntity);
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoading());
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onGetAccounts(
      GetAccounts event, Emitter<AccountState> emit) async {
    List<AccountEntity> accounts = await getAccountsUsecase.call();
    emit(AccountLoading());
    emit(AccountLoaded(accounts: accounts));
  }

  Future<void> _onSetPrimaryAccount(
      SetPrimaryAccount event, Emitter<AccountState> emit) async {
    await setPrimaryAccountUsecase.call(event.accountId);
    List<AccountEntity> accounts = await getAccountsUsecase.call();
    emit(AccountLoading());
    emit(AccountLoaded(accounts: accounts));
  }

  
}
