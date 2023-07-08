import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/usecases/main_transaction/create_main_transaction_usecase.dart';
import 'package:coin_saver/features/domain/usecases/main_transaction/delete_main_transaction_usecase.dart';
import 'package:coin_saver/features/domain/usecases/main_transaction/get_main_transactions_usecase.dart';
import 'package:coin_saver/features/domain/usecases/main_transaction/update_main_transaction_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/main_transaction/main_transaction_entity.dart';

part 'main_transaction_event.dart';
part 'main_transaction_state.dart';

class MainTransactionBloc
    extends Bloc<MainTransactionEvent, MainTransactionState> {
  final GetMainTransactionsUsecase getMainTransactionsUsecase;
  final CreateMainTransactionUsecase createMainTransactionUsecase;
  final UpdateMainTransactionUsecase updateMainTransactionUsecase;
  final DeleteMainTransactionUsecase deleteMainTransactionUsecase;
  MainTransactionBloc({
    required this.getMainTransactionsUsecase,
    required this.createMainTransactionUsecase,
    required this.updateMainTransactionUsecase,
    required this.deleteMainTransactionUsecase,
  }) : super(MainTransactionInitial()) {
    on<GetMainTransactions>(_onGetMainTransactions);
    on<CreateMainTransaction>(_onCreateMainTransaction);
    on<DeleteMainTransaction>(_onDeleteMainTransaction);
    on<UpdateMainTransaction>(_onUpdateMainTransaction);
  }

  FutureOr<void> _onGetMainTransactions(
      GetMainTransactions event, Emitter<MainTransactionState> emit) async {
    final List<MainTransactionEntity> mainTransactions =
        await getMainTransactionsUsecase.call();
    emit(MainTransactionLoaded(mainTransactions: mainTransactions));
  }

  FutureOr<void> _onCreateMainTransaction(
      CreateMainTransaction event, Emitter<MainTransactionState> emit) async {
   await createMainTransactionUsecase.call(event.mainTransaction);
    final List<MainTransactionEntity> mainTransactions =
        await getMainTransactionsUsecase.call();
    emit(MainTransactionLoading());

    emit(MainTransactionLoaded(mainTransactions: mainTransactions));

    print(mainTransactions.length);
  }

  FutureOr<void> _onDeleteMainTransaction(
      DeleteMainTransaction event, Emitter<MainTransactionState> emit) async {
    await deleteMainTransactionUsecase.call(event.id);
    final List<MainTransactionEntity> mainTransactions =
        await getMainTransactionsUsecase.call();
    emit(MainTransactionLoaded(mainTransactions: mainTransactions));
  }

  FutureOr<void> _onUpdateMainTransaction(
      UpdateMainTransaction event, Emitter<MainTransactionState> emit) async {
    await updateMainTransactionUsecase.call(
        event.oldKey, event.mainTransaction);
    final List<MainTransactionEntity> mainTransactions =
        await getMainTransactionsUsecase.call();
    emit(MainTransactionLoaded(mainTransactions: mainTransactions));
  }
}
