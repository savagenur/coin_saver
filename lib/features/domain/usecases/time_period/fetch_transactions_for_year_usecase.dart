import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class FetchTransactionsForYearUsecase {
  final BaseHiveRepository repository;
  FetchTransactionsForYearUsecase({
    required this.repository,
  });

  List<TransactionEntity> call(
      DateTime selectedDate, List<TransactionEntity> totalTransactions) {
    return repository.fetchTransactionsForYear(selectedDate, totalTransactions);
  }
}
