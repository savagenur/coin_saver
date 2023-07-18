import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/add_transaction_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/delete_transaction_usecase.dart';
import 'package:equatable/equatable.dart';

import 'package:coin_saver/features/domain/usecases/account/create_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/delete_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/get_accounts_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/update_account_usecase.dart';

import '../../../domain/entities/account/account_entity.dart';
import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../../domain/usecases/account/set_primary_account_usecase.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final CreateAccountUsecase createAccountUsecase;
  final GetAccountsUsecase getAccountsUsecase;
  final UpdateAccountUsecase updateAccountUsecase;
  final DeleteAccountUsecase deleteAccountUsecase;
  final SetPrimaryAccountUsecase setPrimaryAccountUsecase;
  final AddTransactionUsecase addTransactionUsecase;
  final DeleteTransactionUsecase deleteTransactionUsecase;
  AccountBloc({
    required this.createAccountUsecase,
    required this.getAccountsUsecase,
    required this.updateAccountUsecase,
    required this.deleteAccountUsecase,
    required this.setPrimaryAccountUsecase,
    required this.addTransactionUsecase,
    required this.deleteTransactionUsecase,
  }) : super(AccountInitial()) {
    on<CreateAccount>(_onCreateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<SetPrimaryAccount>(_onSetPrimaryAccount);
    on<GetAccounts>(_onGetAccounts);

    // Transaction
    // on<AddTransaction>(_onAddTransaction);
    // on<DeleteTransaction>(_onDeleteTransaction);
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

  Future<void> _onSetPrimaryAccount(
      SetPrimaryAccount event, Emitter<AccountState> emit) async {
    await setPrimaryAccountUsecase.call(event.accountId);
    List<AccountEntity> accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }

  // Transaction
  // FutureOr<void> _onAddTransaction(
  //     AddTransaction event, Emitter<AccountState> emit) async {
  //   await setPrimaryAccountUsecase.call(event.accountEntity.id);
  //   await addTransactionUsecase.call(event.accountEntity,
  //       event.transactionEntity, );

  //   final accounts = await getAccountsUsecase.call();

  //   emit(AccountLoaded(accounts: accounts));
  // }

  // FutureOr<void> _onDeleteTransaction(
  //     DeleteTransaction event, Emitter<AccountState> emit) async {
  //   await deleteTransactionUsecase.call(
  //       event.accountEntity, event.transactionEntity);

  //   final accounts = await getAccountsUsecase.call();

  //   emit(AccountLoaded(accounts: accounts));
  // }

  Future<List<AccountEntity>> getAccountsWithTotal(
    String accountId,
  ) async {
    List<AccountEntity> accounts = await getAccountsUsecase.call();

    if (accountId == "total") {
      double totalBalance = 0;
      List<TransactionEntity> totalTransactions = [];
      for (var account in accounts) {
        totalBalance += account.balance;
        totalTransactions.addAll(account.transactionHistory);
      }
      AccountEntity updatedTotalAccount = accounts
          .firstWhere((account) => account.id == accountId)
          .copyWith(
              balance: totalBalance, transactionHistory: totalTransactions);

      int index = accounts.indexWhere((account) => account.id == accountId);
      if (index != -1) {
        accounts[index] = updatedTotalAccount;
      }
    }
    return accounts;
  }
}
