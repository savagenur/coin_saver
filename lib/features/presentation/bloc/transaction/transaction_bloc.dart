import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/usecases/transaction/get_transactions_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/account/account_entity.dart';
import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../../domain/usecases/transaction/add_transaction_usecase.dart';
import '../../../domain/usecases/transaction/add_transfer_usecase.dart';
import '../../../domain/usecases/transaction/delete_transaction_usecase.dart';
import '../../../domain/usecases/transaction/delete_transfer_usecase.dart';
import '../../../domain/usecases/transaction/update_transaction_usecase.dart';
import '../../../domain/usecases/transaction/update_transfer_usecase.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  // Transactions usecases
  final AddTransactionUsecase addTransactionUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;
  final DeleteTransactionUsecase deleteTransactionUsecase;
  final GetTransactionsUsecase getTransactionsUsecase;
// Transfers usecases

  final AddTransferUsecase addTransferUsecase;
  final DeleteTransferUsecase deleteTransferUsecase;
  final UpdateTransferUsecase updateTransferUsecase;
  TransactionBloc({
    required this.addTransactionUsecase,
    required this.deleteTransactionUsecase,
    required this.addTransferUsecase,
    required this.deleteTransferUsecase,
    required this.updateTransferUsecase,
    required this.updateTransactionUsecase,
    required this.getTransactionsUsecase,
  }) : super(const TransactionState(transactions: [])) {
    on<AddTransfer>(_onAddTransfer);
    on<UpdateTransfer>(_onUpdateTransfer);
    on<DeleteTransfer>(_onDeleteTransfer);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<GetTransactions>(_onGetTransactions);
  }

  FutureOr<void> _onAddTransfer(
      AddTransfer event, Emitter<TransactionState> emit) async {
    await addTransferUsecase.call(
        accountFrom: event.accountFrom,
        accountTo: event.accountTo,
        transactionEntity: event.transactionEntity);
    final transactions = await getTransactionsUsecase.call();
    emit(TransactionState(transactions: transactions));
  }

  FutureOr<void> _onUpdateTransfer(
      UpdateTransfer event, Emitter<TransactionState> emit) async {
    await updateTransferUsecase.call(
        accountFrom: event.accountFrom,
        accountTo: event.accountTo,
        oldAccountTo: event.oldAccountTo,
        oldAccountFrom: event.oldAccountFrom,
        transactionEntity: event.transactionEntity);
    final transactions = await getTransactionsUsecase.call();
    emit(TransactionState(transactions: transactions));
  }

  FutureOr<void> _onDeleteTransfer(
      DeleteTransfer event, Emitter<TransactionState> emit) async {
    await deleteTransferUsecase.call(
        accountFrom: event.accountFrom,
        accountTo: event.accountTo,
        transactionEntity: event.transactionEntity);
    final transactions = await getTransactionsUsecase.call();
    emit(TransactionState(transactions: transactions));
  }

  FutureOr<void> _onAddTransaction(
      AddTransaction event, Emitter<TransactionState> emit) async {
    await addTransactionUsecase.call(event.account, event.transaction);

    final transactions = await getTransactionsUsecase.call();
    print("transactions: ${transactions.length}");
    emit(TransactionState(transactions: transactions));
  }

  FutureOr<void> _onDeleteTransaction(
      DeleteTransaction event, Emitter<TransactionState> emit) async {
    await deleteTransactionUsecase.call(event.account, event.transaction);
    final transactions = await getTransactionsUsecase.call();
    emit(TransactionState(transactions: transactions));
  }

  FutureOr<void> _onUpdateTransaction(
      UpdateTransaction event, Emitter<TransactionState> emit) async {
    await updateTransactionUsecase.call(event.account, event.transaction);
    final transactions = await getTransactionsUsecase.call();
    emit(TransactionState(transactions: transactions));
  }

  FutureOr<void> _onGetTransactions(
      GetTransactions event, Emitter<TransactionState> emit) async {
    final transactions = await getTransactionsUsecase.call();
    emit(TransactionState(transactions: transactions));
  }
}
