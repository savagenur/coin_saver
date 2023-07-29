
import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/presentation/bloc/account/account_bloc.dart';
import 'package:coin_saver/injection_container.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../../domain/usecases/account/set_primary_account_usecase.dart';
import '../../../domain/usecases/account/transaction/add_transaction_usecase.dart';
import '../../../domain/usecases/account/transaction/delete_transaction_usecase.dart';
import '../../../domain/usecases/account/transaction/get_transactions_usecase.dart';
import '../../../domain/usecases/account/transaction/update_transaction_usecase.dart';

part 'main_transaction_event.dart';
part 'main_transaction_state.dart';

class MainTransactionBloc
    extends Bloc<MainTransactionEvent, MainTransactionState> {
  final GetTransactionsUsecase getTransactionsUsecase;
  final AddTransactionUsecase addTransactionUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;
  final DeleteTransactionUsecase deleteTransactionUsecase;
  final SetPrimaryAccountUsecase setPrimaryAccountUsecase;

  MainTransactionBloc({
    required this.getTransactionsUsecase,
    required this.addTransactionUsecase,
    required this.updateTransactionUsecase,
    required this.deleteTransactionUsecase,
    required this.setPrimaryAccountUsecase,
  }) : super(MainTransactionInitial()) {
    on<GetTransactions>(_onGetTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
  }

  Future<void> _onGetTransactions(
      GetTransactions event, Emitter<MainTransactionState> emit) async {
    final List<TransactionEntity> transactions =
        await getTransactionsUsecase.call();
    emit(MainTransactionLoading());
    emit(MainTransactionLoaded(transactions: transactions));
  }

  Future<void> _onAddTransaction(
      AddTransaction event, Emitter<MainTransactionState> emit) async {
    await addTransactionUsecase.call(event.account, event.transaction);
    final List<TransactionEntity> transactions =
        await getTransactionsUsecase.call();
    emit(MainTransactionLoading());

    emit(MainTransactionLoaded(transactions: transactions));
  }

  Future<void> _onDeleteTransaction(
      DeleteTransaction event, Emitter<MainTransactionState> emit) async {
    await deleteTransactionUsecase.call(event.account, event.transaction);
    final List<TransactionEntity> transactions =
        await getTransactionsUsecase.call();
    sl<AccountBloc>().add(GetAccounts());
    emit(MainTransactionLoading());
    emit(MainTransactionLoaded(transactions: transactions));
  }

  Future<void> _onUpdateTransaction(
      UpdateTransaction event, Emitter<MainTransactionState> emit) async {
    await updateTransactionUsecase.call(event.account, event.transaction);
    final List<TransactionEntity> transactions =
        await getTransactionsUsecase.call();
    emit(MainTransactionLoading());
    emit(MainTransactionLoaded(transactions: transactions));
  }
}
