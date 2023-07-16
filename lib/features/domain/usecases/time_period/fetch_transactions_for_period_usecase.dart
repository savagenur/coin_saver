import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class FetchTransactionsForPeriodUsecase {
  final BaseHiveRepository repository;
  FetchTransactionsForPeriodUsecase({
    required this.repository,
  });

  List<TransactionEntity> call(
      DateTime selectedStart,DateTime selectedEnd, List<TransactionEntity> totalTransactions) {
    return repository.fetchTransactionsForPeriod(selectedStart, selectedEnd, totalTransactions);
  }
}
