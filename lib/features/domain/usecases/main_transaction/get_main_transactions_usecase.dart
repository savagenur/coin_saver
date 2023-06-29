import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class GetMainTransactionsUsecase {
  final BaseHiveRepository repository;
  GetMainTransactionsUsecase({
    required this.repository,
  });
  Future<List<MainTransactionEntity>> call() async {
    return repository.getMainTransactions();
  }
}
