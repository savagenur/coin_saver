import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../../domain/usecases/account/transaction/add_transaction_usecase.dart';
import '../../../domain/usecases/account/transaction/delete_transaction_usecase.dart';
import '../../../domain/usecases/account/transaction/get_transactions_usecase.dart';
import '../../../domain/usecases/account/transaction/update_transaction_usecase.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUsecase getTransactionsUsecase;
  final AddTransactionUsecase addTransactionUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;
  final DeleteTransactionUsecase deleteTransactionUsecase;
  TransactionBloc({
    required this.getTransactionsUsecase,
    required this.addTransactionUsecase,
    required this.updateTransactionUsecase,
    required this.deleteTransactionUsecase,
  }) : super(TransactionInitial()) {
    on<GetTransactions>(_onGetTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
  }

  Future<void> _onGetTransactions(
      GetTransactions event, Emitter<TransactionState> emit) async {
    final List<TransactionEntity> transactions =
        await getTransactionsUsecase.call();
    emit(TransactionLoaded(transactions: transactions));
  }

  Future<void> _onAddTransaction(
      AddTransaction event, Emitter<TransactionState> emit) async {
   await addTransactionUsecase.call(event.account, event.transaction);
    final List<TransactionEntity> transactions =
        await getTransactionsUsecase.call();
    emit(TransactionLoading());

    emit(TransactionLoaded(transactions: transactions));
  }

  Future<void> _onDeleteTransaction(
      DeleteTransaction event, Emitter<TransactionState> emit) async {
    await deleteTransactionUsecase.call(event.account, event.transaction);
    final List<TransactionEntity> transactions =
        await getTransactionsUsecase.call();
    emit(TransactionLoaded(transactions: transactions));
  }

  Future<void> _onUpdateTransaction(
      UpdateTransaction event, Emitter<TransactionState> emit) async {
    updateTransactionUsecase.call(event.account, event.transaction);
    final List<TransactionEntity> transactions =
        await getTransactionsUsecase.call();
    emit(TransactionLoaded(transactions: transactions));
  }
}
