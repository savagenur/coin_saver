import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class FetchTransactionsForWeekUsecase {
  final BaseHiveRepository repository;
  FetchTransactionsForWeekUsecase({
    required this.repository,
  });

  List<TransactionEntity> call(
      DateTime selectedDate, List<TransactionEntity> totalTransactions) {
    return repository.fetchTransactionsForWeek(selectedDate, totalTransactions);
  }
}
