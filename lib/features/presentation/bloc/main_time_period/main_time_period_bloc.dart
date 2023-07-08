import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/usecases/main_time_period/get_main_transactions_for_today_usecase.dart';
import 'package:coin_saver/features/domain/usecases/main_transaction/get_main_transactions_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/main_transaction/main_transaction_entity.dart';
import '../../../domain/usecases/main_time_period/fetch_main_transactions_for_day_usecase.dart';
import '../../../domain/usecases/main_time_period/fetch_main_transactions_for_month_usecase.dart';
import '../../../domain/usecases/main_time_period/fetch_main_transactions_for_week_usecase.dart';
import '../../../domain/usecases/main_time_period/fetch_main_transactions_for_year_usecase.dart';

part 'main_time_period_event.dart';
part 'main_time_period_state.dart';

class MainTimePeriodBloc
    extends Bloc<MainTimePeriodEvent, MainTimePeriodState> {
  final GetMainTransactionsForTodayUsecase getMainTransactionsForTodayUsecase;
  final FetchMainTransactionsForDayUsecase fetchMainTransactionsForDayUsecase;
  final FetchMainTransactionsForWeekUsecase fetchMainTransactionsForWeekUsecase;
  final FetchMainTransactionsForMonthUsecase
      fetchMainTransactionsForMonthUsecase;
  final FetchMainTransactionsForYearUsecase fetchMainTransactionsForYearUsecase;
  final GetMainTransactionsUsecase getMainTransactionsUsecase;

  MainTimePeriodBloc({
    required this.fetchMainTransactionsForDayUsecase,
    required this.getMainTransactionsForTodayUsecase,
    required this.fetchMainTransactionsForWeekUsecase,
    required this.fetchMainTransactionsForMonthUsecase,
    required this.fetchMainTransactionsForYearUsecase,
    required this.getMainTransactionsUsecase,
  }) : super(MainTimePeriodLoading()) {
    on<SetDayPeriod>(_onSetDayPeriod);
    on<GetTodayPeriod>(_onGetTodayPeriod);
    on<SetMonthPeriod>(_onSetMonthPeriod);
    on<SetWeekPeriod>(_onSetWeekPeriod);
    on<SetYearPeriod>(_onSetYearPeriod);
  }
  void _onSetDayPeriod(
      SetDayPeriod event, Emitter<MainTimePeriodState> emit) async {
    final selectedDate = event.selectedDate;
    final mainTransactions = await getMainTransactionsUsecase.call();
    emit(
      MainTimePeriodLoaded(
        selectedPeriod: selectedDate,
        transactions: fetchMainTransactionsForDayUsecase.call(
          selectedDate,
          mainTransactions,
        ),
      ),
    );
  }

  void _onGetTodayPeriod(
      GetTodayPeriod event, Emitter<MainTimePeriodState> emit) async {
    emit(
      MainTimePeriodLoaded(
        selectedPeriod: DateTime.now(),
        transactions: getMainTransactionsForTodayUsecase.call(),
      ),
    );
  }

  void _onSetWeekPeriod(
      SetWeekPeriod event, Emitter<MainTimePeriodState> emit) async {
    final selectedDate = event.selectedDate;
    final transactions = await getMainTransactionsUsecase.call();
    final totalTransactions = fetchMainTransactionsForWeekUsecase.call(
      selectedDate,
      transactions,
    );
    List<MainTransactionEntity> summedTransactions = [];

    for (var transaction in totalTransactions) {
      final existingTransaction = summedTransactions.firstWhere(
          (t) =>
              t.name == transaction.name &&
              t.accountId == transaction.accountId,
          orElse: () => transaction.copyWith(name: "null"));
      if (existingTransaction.name != "null") {
        double amount = existingTransaction.totalAmount;
        final double totalAmount = amount + transaction.totalAmount;
        summedTransactions.remove(existingTransaction);
        summedTransactions
            .add(existingTransaction.copyWith(totalAmount: totalAmount));
      } else {
        summedTransactions.add(
          transaction,
        );
      }
    }

    emit(
      MainTimePeriodLoaded(
        selectedPeriod: event.selectedDate,
        transactions: summedTransactions,
      ),
    );
  }

  void _onSetMonthPeriod(
      SetMonthPeriod event, Emitter<MainTimePeriodState> emit) async {
    final selectedDate = event.selectedDate;
    final transactions = await getMainTransactionsUsecase.call();
    final totalTransactions = fetchMainTransactionsForMonthUsecase.call(
      selectedDate,
      transactions,
    );
    List<MainTransactionEntity> summedTransactions = [];

    for (var transaction in totalTransactions) {
      final existingTransaction = summedTransactions.firstWhere(
          (t) => t.name == transaction.name &&
              t.accountId == transaction.accountId,
          orElse: () => transaction.copyWith(name: "null"));
      if (existingTransaction.name != "null") {
        double amount = existingTransaction.totalAmount;
        final double totalAmount = amount + transaction.totalAmount;
        summedTransactions.remove(existingTransaction);
        summedTransactions
            .add(existingTransaction.copyWith(totalAmount: totalAmount));
      } else {
        summedTransactions.add(
          transaction,
        );
      }
    }

    emit(
      MainTimePeriodLoaded(
        selectedPeriod: event.selectedDate,
        transactions: summedTransactions,
      ),
    );
  }

  void _onSetYearPeriod(
      SetYearPeriod event, Emitter<MainTimePeriodState> emit) async {
    final selectedDate = event.selectedDate;
    final transactions = await getMainTransactionsUsecase.call();
    final totalTransactions = fetchMainTransactionsForYearUsecase.call(
      selectedDate,
      transactions,
    );
    List<MainTransactionEntity> summedTransactions = [];

    for (var transaction in totalTransactions) {
      final MainTransactionEntity existingTransaction =
          summedTransactions.firstWhere((t) => t.name == transaction.name &&
              t.accountId == transaction.accountId,
              orElse: () => transaction.copyWith(name: "null"));
      if (existingTransaction.name != "null") {
        double amount = existingTransaction.totalAmount;
        final double totalAmount = amount + transaction.totalAmount;
        summedTransactions.remove(existingTransaction);
        summedTransactions
            .add(existingTransaction.copyWith(totalAmount: totalAmount));
      } else {
        summedTransactions.add(
          transaction,
        );
      }
    }

    emit(
      MainTimePeriodLoaded(
        selectedPeriod: event.selectedDate,
        transactions: summedTransactions,
      ),
    );
  }
}
