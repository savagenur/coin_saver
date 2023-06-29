import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class UpdateMainTransactionUsecase {
  final BaseHiveRepository repository;
  UpdateMainTransactionUsecase({
    required this.repository,
  });
  Future<void> call(String oldKey, MainTransactionEntity mainTransactionEntity) async {
    return repository.updateMainTransaction(oldKey,mainTransactionEntity);
  }

  
}
