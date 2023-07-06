
import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/usecases/time_period/fetch_transactions_for_day_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/transaction/transaction_entity.dart';
import '../../../domain/usecases/time_period/fetch_transactions_for_month_usecase.dart';
import '../../../domain/usecases/time_period/fetch_transactions_for_week_usecase.dart';
import '../../../domain/usecases/time_period/fetch_transactions_for_year_usecase.dart';

part 'time_period_event.dart';
part 'time_period_state.dart';

class TimePeriodBloc extends Bloc<TimePeriodEvent, TimePeriodState> {
  final FetchTransactionsForDayUsecase fetchTransactionsForDayUsecase;
  final FetchTransactionsForWeekUsecase fetchTransactionsForWeekUsecase;
  final FetchTransactionsForMonthUsecase fetchTransactionsForMonthUsecase;
  final FetchTransactionsForYearUsecase fetchTransactionsForYearUsecase;
  TimePeriodBloc({
    required this.fetchTransactionsForDayUsecase,
    required this.fetchTransactionsForWeekUsecase,
    required this.fetchTransactionsForMonthUsecase,
    required this.fetchTransactionsForYearUsecase,
  }) : super(TimePeriodState(
            selectedPeriod: DateTime.now(), transactions: const [])) {
    on<SetDayPeriod>(_onSetDayPeriod);
    on<SetWeekPeriod>(_onSetWeekPeriod);
    on<SetMonthPeriod>(_onSetMonthPeriod);
    on<SetYearPeriod>(_onSetYearPeriod);
  }

  void _onSetDayPeriod(
      SetDayPeriod event, Emitter<TimePeriodState> emit) async {
    final selectedDate = event.selectedDate;
    final totalTransactions = event.transactions;

    emit(
      TimePeriodState(
        selectedPeriod: event.selectedDate,
        transactions: fetchTransactionsForDayUsecase.call(
          selectedDate,
          totalTransactions,
        ),
      ),
    );
  }

  void _onSetWeekPeriod(
      SetWeekPeriod event, Emitter<TimePeriodState> emit) {
    final selectedDate = event.selectedDate;
    final totalTransactions = event.transactions;

    emit(
      TimePeriodState(
        selectedPeriod: event.selectedDate,
        transactions: fetchTransactionsForWeekUsecase.call(
          selectedDate,
          totalTransactions,
        ),
      ),
    );
  }

  void _onSetMonthPeriod(
      SetMonthPeriod event, Emitter<TimePeriodState> emit) {
    final selectedDate = event.selectedDate;
    final totalTransactions = event.transactions;

    emit(
      TimePeriodState(
        selectedPeriod: event.selectedDate,
        transactions: fetchTransactionsForMonthUsecase.call(
          selectedDate,
          totalTransactions,
        ),
      ),
    );
  }

  void _onSetYearPeriod(
      SetYearPeriod event, Emitter<TimePeriodState> emit) {
    final selectedDate = event.selectedDate;
    final totalTransactions = event.transactions;

    emit(
      TimePeriodState(
        selectedPeriod: event.selectedDate,
        transactions: fetchTransactionsForYearUsecase.call(
          selectedDate,
          totalTransactions,
        ),
      ),
    );
  }
}
