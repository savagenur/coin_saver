import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class GetTransactionsForTodayUsecase {
  final BaseHiveRepository repository;
  GetTransactionsForTodayUsecase({
    required this.repository,
  });

  List<TransactionEntity> call() {
    return repository.getTransactionsForToday();
  }
}
