import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/usecases/time_period/get_transactions_for_today_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../../domain/usecases/account/transaction/get_transactions_usecase.dart';
import '../../../domain/usecases/time_period/fetch_transactions_for_day_usecase.dart';
import '../../../domain/usecases/time_period/fetch_transactions_for_month_usecase.dart';
import '../../../domain/usecases/time_period/fetch_transactions_for_period_usecase.dart';
import '../../../domain/usecases/time_period/fetch_transactions_for_week_usecase.dart';
import '../../../domain/usecases/time_period/fetch_transactions_for_year_usecase.dart';

part 'time_period_event.dart';
part 'time_period_state.dart';

class TimePeriodBloc extends Bloc<TimePeriodEvent, TimePeriodState> {
  final GetTransactionsForTodayUsecase getTransactionsForTodayUsecase;
  final FetchTransactionsForDayUsecase fetchTransactionsForDayUsecase;
  final FetchTransactionsForWeekUsecase fetchTransactionsForWeekUsecase;
  final FetchTransactionsForMonthUsecase fetchTransactionsForMonthUsecase;
  final FetchTransactionsForYearUsecase fetchTransactionsForYearUsecase;
  final FetchTransactionsForPeriodUsecase fetchTransactionsForPeriodUsecase;
  final GetTransactionsUsecase getTransactionsUsecase;

  TimePeriodBloc({
    required this.fetchTransactionsForDayUsecase,
    required this.getTransactionsForTodayUsecase,
    required this.fetchTransactionsForWeekUsecase,
    required this.fetchTransactionsForMonthUsecase,
    required this.fetchTransactionsForYearUsecase,
    required this.fetchTransactionsForPeriodUsecase,
    required this.getTransactionsUsecase,
  }) : super(TimePeriodLoading()) {
    on<SetDayPeriod>(_onSetDayPeriod);
    on<GetTodayPeriod>(_onGetTodayPeriod);
    on<SetMonthPeriod>(_onSetMonthPeriod);
    on<SetWeekPeriod>(_onSetWeekPeriod);
    on<SetYearPeriod>(_onSetYearPeriod);
    on<SetPeriod>(_onSetPeriod);
  }
  void _onSetDayPeriod(
      SetDayPeriod event, Emitter<TimePeriodState> emit) async {
    final selectedDate = event.selectedDate;
    final transactions = await getTransactionsUsecase.call();
    final totalTransactions = fetchTransactionsForDayUsecase.call(
      selectedDate,
      transactions,
    );
    List<TransactionEntity> summedTransactions = [];

    for (var transaction in totalTransactions) {
      final existingTransaction = summedTransactions.firstWhere(
          (t) => t.category == transaction.category,
          orElse: () => transaction.copyWith(id: ""));
      if (existingTransaction.id != "") {
        double amount = existingTransaction.amount;
        final double totalAmount = amount + transaction.amount;
        summedTransactions.remove(existingTransaction);
        summedTransactions
            .add(existingTransaction.copyWith(amount: totalAmount));
      } else {
        summedTransactions.add(
          transaction,
        );
      }
    }

    emit(
      TimePeriodLoaded(
        selectedDate: event.selectedDate,
        transactions: summedTransactions,
      ),
    );
  }

  void _onGetTodayPeriod(
      GetTodayPeriod event, Emitter<TimePeriodState> emit) async {
    emit(
      TimePeriodLoaded(
        selectedDate: DateTime.now(),
        transactions: getTransactionsForTodayUsecase.call(),
      ),
    );
  }

  void _onSetWeekPeriod(
    SetWeekPeriod event,
    Emitter<TimePeriodState> emit,
  ) async {
    final selectedDate = event.selectedDate;
    final transactions = await getTransactionsUsecase.call();
    final totalTransactions = fetchTransactionsForWeekUsecase.call(
      selectedDate,
      transactions,
    );
    List<TransactionEntity> summedTransactions = [];

    for (var transaction in totalTransactions) {
      final existingTransaction = summedTransactions.firstWhere(
          (t) => t.category == transaction.category,
          orElse: () => transaction.copyWith(id: ""));
      if (existingTransaction.id != "") {
        double amount = existingTransaction.amount;
        final double totalAmount = amount + transaction.amount;
        summedTransactions.remove(existingTransaction);
        summedTransactions
            .add(existingTransaction.copyWith(amount: totalAmount));
      } else {
        summedTransactions.add(
          transaction,
        );
      }
    }

    emit(
      TimePeriodLoaded(
        selectedDate: event.selectedDate,
        transactions: summedTransactions,
      ),
    );
  }

  void _onSetMonthPeriod(
      SetMonthPeriod event, Emitter<TimePeriodState> emit) async {
    final selectedDate = event.selectedDate;
    final transactions = await getTransactionsUsecase.call();
    final totalTransactions = fetchTransactionsForMonthUsecase.call(
      selectedDate,
      transactions,
    );
    List<TransactionEntity> summedTransactions = [];

    for (var transaction in totalTransactions) {
      final existingTransaction = summedTransactions.firstWhere(
          (t) => t.category == transaction.category,
          orElse: () => transaction.copyWith(id: ""));
      if (existingTransaction.id != "") {
        double amount = existingTransaction.amount;
        final double totalAmount = amount + transaction.amount;
        summedTransactions.remove(existingTransaction);
        summedTransactions
            .add(existingTransaction.copyWith(amount: totalAmount));
      } else {
        summedTransactions.add(
          transaction,
        );
      }
    }

    emit(
      TimePeriodLoaded(
        selectedDate: event.selectedDate,
        transactions: summedTransactions,
      ),
    );
  }

  void _onSetYearPeriod(
      SetYearPeriod event, Emitter<TimePeriodState> emit) async {
    final selectedDate = event.selectedDate;
    final transactions = await getTransactionsUsecase.call();
    final totalTransactions = fetchTransactionsForYearUsecase.call(
      selectedDate,
      transactions,
    );
    List<TransactionEntity> summedTransactions = [];

    for (var transaction in totalTransactions) {
      final TransactionEntity existingTransaction = summedTransactions
          .firstWhere((t) => t.category == transaction.category,
              orElse: () => transaction.copyWith(id: ""));
      if (existingTransaction.id != "") {
        double amount = existingTransaction.amount;
        final double totalAmount = amount + transaction.amount;
        summedTransactions.remove(existingTransaction);
        summedTransactions
            .add(existingTransaction.copyWith(amount: totalAmount));
      } else {
        summedTransactions.add(
          transaction,
        );
      }
    }

    emit(
      TimePeriodLoaded(
        selectedDate: event.selectedDate,
        transactions: summedTransactions,
      ),
    );
  }

  void _onSetPeriod(SetPeriod event, Emitter<TimePeriodState> emit) async {
    final selectedStart = event.selectedStart;
    final selectedEnd = event.selectedEnd;
    final transactions = await getTransactionsUsecase.call();
    final totalTransactions = fetchTransactionsForPeriodUsecase.call(
      selectedStart,
      selectedEnd,
      transactions,
    );
    print(totalTransactions.length);
    List<TransactionEntity> summedTransactions = [];

    for (var transaction in totalTransactions) {
      final existingTransaction = summedTransactions.firstWhere(
          (t) => t.category == transaction.category,
          orElse: () => transaction.copyWith(id: ""));
      if (existingTransaction.id != "") {
        double amount = existingTransaction.amount;
        final double totalAmount = amount + transaction.amount;
        summedTransactions.remove(existingTransaction);
        summedTransactions
            .add(existingTransaction.copyWith(amount: totalAmount));
      } else {
        summedTransactions.add(
          transaction,
        );
      }
    }

    emit(
      TimePeriodLoaded(
        selectedDate: event.selectedStart,
        transactions: summedTransactions,
      ),
    );
  }
}
