import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class CreateMainTransactionUsecase {
  final BaseHiveRepository repository;
  CreateMainTransactionUsecase({
    required this.repository,
  });
  Future<void> call(MainTransactionEntity mainTransactionEntity) async {
    return repository.createMainTransaction(mainTransactionEntity);
  }

  
}
