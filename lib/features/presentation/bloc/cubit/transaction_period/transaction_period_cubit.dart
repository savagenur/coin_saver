import 'package:bloc/bloc.dart';

import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/usecases/time_period/fetch_transactions_for_day_usecase.dart';

import '../../../../../constants/period_enum.dart';
import '../../../../domain/usecases/time_period/fetch_transactions_for_month_usecase.dart';
import '../../../../domain/usecases/time_period/fetch_transactions_for_period_usecase.dart';
import '../../../../domain/usecases/time_period/fetch_transactions_for_week_usecase.dart';
import '../../../../domain/usecases/time_period/fetch_transactions_for_year_usecase.dart';

class TransactionPeriodCubit extends Cubit<List<TransactionEntity>> {
  final FetchTransactionsForDayUsecase fetchTransactionsForDayUsecase;
  final FetchTransactionsForWeekUsecase fetchTransactionsForWeekUsecase;
  final FetchTransactionsForMonthUsecase fetchTransactionsForMonthUsecase;
  final FetchTransactionsForYearUsecase fetchTransactionsForYearUsecase;
  final FetchTransactionsForPeriodUsecase fetchTransactionsForPeriodUsecase;
  TransactionPeriodCubit({
    required this.fetchTransactionsForDayUsecase,
    required this.fetchTransactionsForWeekUsecase,
    required this.fetchTransactionsForMonthUsecase,
    required this.fetchTransactionsForYearUsecase,
    required this.fetchTransactionsForPeriodUsecase,
  }) : super([]);

  void setPeriod({
    required Period period,
    required DateTime selectedDate,
    required List<TransactionEntity> totalTransactions,
    required DateTime selectedEnd,
  }) {
    List<TransactionEntity> transactions = [];
    switch (period) {
      case Period.day:
        transactions = fetchTransactionsForDayUsecase.call(
            selectedDate, totalTransactions);
        break;
      case Period.week:
        transactions = fetchTransactionsForWeekUsecase.call(
            selectedDate, totalTransactions);
        break;
      case Period.month:
        transactions = fetchTransactionsForMonthUsecase.call(
            selectedDate, totalTransactions);
        break;
      case Period.year:
        transactions = fetchTransactionsForYearUsecase.call(
            selectedDate, totalTransactions);
        break;
      case Period.period:
        transactions = fetchTransactionsForPeriodUsecase.call(
            selectedDate, selectedEnd, totalTransactions);
        break;
      default:
    }

    emit(transactions);
  }

  
}
