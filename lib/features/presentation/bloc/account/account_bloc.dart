import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/add_transaction_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/add_transfer_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/transaction/delete_transaction_usecase.dart';
import 'package:equatable/equatable.dart';

import 'package:coin_saver/features/domain/usecases/account/create_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/delete_account_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/get_accounts_usecase.dart';
import 'package:coin_saver/features/domain/usecases/account/update_account_usecase.dart';

import '../../../domain/entities/account/account_entity.dart';
import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../../domain/usecases/account/set_primary_account_usecase.dart';
import '../../../domain/usecases/account/transaction/delete_transfer_usecase.dart';
import '../../../domain/usecases/account/transaction/get_transactions_usecase.dart';
import '../../../domain/usecases/account/transaction/update_transaction_usecase.dart';
import '../../../domain/usecases/account/transaction/update_transfer_usecase.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final CreateAccountUsecase createAccountUsecase;
  final GetAccountsUsecase getAccountsUsecase;
  final UpdateAccountUsecase updateAccountUsecase;
  final DeleteAccountUsecase deleteAccountUsecase;
  final SetPrimaryAccountUsecase setPrimaryAccountUsecase;

// Transactions usecases
  final AddTransactionUsecase addTransactionUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;
  final DeleteTransactionUsecase deleteTransactionUsecase;
// Transfers usecases

  final AddTransferUsecase addTransferUsecase;
  final DeleteTransferUsecase deleteTransferUsecase;
  final UpdateTransferUsecase updateTransferUsecase;
  AccountBloc({
    required this.createAccountUsecase,
    required this.getAccountsUsecase,
    required this.updateAccountUsecase,
    required this.deleteAccountUsecase,
    required this.setPrimaryAccountUsecase,
    required this.addTransactionUsecase,
    required this.deleteTransactionUsecase,
    required this.addTransferUsecase,
    required this.deleteTransferUsecase,
    required this.updateTransferUsecase,
    required this.updateTransactionUsecase,
  }) : super(AccountInitial()) {
    on<CreateAccount>(_onCreateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<SetPrimaryAccount>(_onSetPrimaryAccount);
    on<GetAccounts>(_onGetAccounts);
    on<AddTransfer>(_onAddTransfer);
    on<UpdateTransfer>(_onUpdateTransfer);
    on<DeleteTransfer>(_onDeleteTransfer);

    // Transaction
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
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

  FutureOr<void> _onAddTransfer(
      AddTransfer event, Emitter<AccountState> emit) async {
    await addTransferUsecase.call(
        accountFrom: event.accountFrom,
        accountTo: event.accountTo,
        transactionEntity: event.transactionEntity);
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onUpdateTransfer(
      UpdateTransfer event, Emitter<AccountState> emit) async {
    await updateTransferUsecase.call(
        accountFrom: event.accountFrom,
        accountTo: event.accountTo,
        oldAccountTo: event.oldAccountTo,
        oldAccountFrom: event.oldAccountFrom,
        transactionEntity: event.transactionEntity);
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onDeleteTransfer(
      DeleteTransfer event, Emitter<AccountState> emit) async {
    await deleteTransferUsecase.call(
        accountFrom: event.accountFrom,
        accountTo: event.accountTo,
        transactionEntity: event.transactionEntity);
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onAddTransaction(
      AddTransaction event, Emitter<AccountState> emit) async {
    await addTransactionUsecase.call(event.account, event.transaction);

    final accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onDeleteTransaction(
      DeleteTransaction event, Emitter<AccountState> emit) async {
    await deleteTransactionUsecase.call(event.account, event.transaction);
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }

  FutureOr<void> _onUpdateTransaction(
      UpdateTransaction event, Emitter<AccountState> emit) async {
    await updateTransactionUsecase.call(event.account, event.transaction);
    final accounts = await getAccountsUsecase.call();
    emit(AccountLoaded(accounts: accounts));
  }
}
