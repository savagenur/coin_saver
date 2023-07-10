import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/add_transaction_usecase.dart';
import 'package:equatable/equatable.dart';

import 'package:coin_saver/features/domain/usecases/account/create_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/delete_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/get_accounts_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/select_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/update_account_usecase.dart';

import '../../../domain/entities/account/account_entity.dart';
import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../../domain/usecases/account/set_primary_account_usecase.dart';
import 'package:coin_saver/injection_container.dart' as di;

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final CreateAccountUsecase createAccountUsecase;
  final GetAccountsUsecase getAccountsUsecase;
  final UpdateAccountUsecase updateAccountUsecase;
  final DeleteAccountUsecase deleteAccountUsecase;
  final SetPrimaryAccountUsecase setPrimaryAccountUsecase;
  final AddTransactionUsecase addTransactionUsecase;
  AccountBloc({
    required this.createAccountUsecase,
    required this.getAccountsUsecase,
    required this.updateAccountUsecase,
    required this.deleteAccountUsecase,
    required this.setPrimaryAccountUsecase,
    required this.addTransactionUsecase,
  }) : super(AccountInitial()) {
    on<CreateAccount>(_onCreateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<AddTransaction>(_onAddTransaction);
    on<SetPrimaryAccount>(_onSetPrimaryAccount);
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

  FutureOr<void> _onAddTransaction(
      AddTransaction event, Emitter<AccountState> emit) async {
    await setPrimaryAccountUsecase.call(event.accountEntity.id);
    await addTransactionUsecase.call(event.accountEntity,
        event.transactionEntity, event.isIncome, event.amount);

    final accounts = await getAccountsUsecase.call();

    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onGetAccounts(
      GetAccounts event, Emitter<AccountState> emit) async {
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onSetPrimaryAccount(
      SetPrimaryAccount event, Emitter<AccountState> emit) async {
    await setPrimaryAccountUsecase.call(event.accountId);
    final accounts = await getAccountsUsecase.call();

    emit(AccountLoaded(accounts: accounts));
  }
}
