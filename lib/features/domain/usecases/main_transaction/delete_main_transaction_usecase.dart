import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

import '../../entities/transaction/transaction_entity.dart';

class DeleteMainTransactionUsecase {
  final BaseHiveRepository repository;
  DeleteMainTransactionUsecase({
    required this.repository,
  });
  Future<void> call(TransactionEntity transactionEntity ) async {
    return repository.deleteMainTransaction( transactionEntity);
  }

  
}
