import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class GetTransactionsUsecase {
  final BaseHiveRepository repository;
  GetTransactionsUsecase({
    required this.repository,
  });

  Future<List<TransactionEntity>> call() async {
    return repository.getTransactions();
  }
}
