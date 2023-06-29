import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class DeleteMainTransactionUsecase {
  final BaseHiveRepository repository;
  DeleteMainTransactionUsecase({
    required this.repository,
  });
  Future<void> call(String id ) async {
    return repository.deleteMainTransaction(id);
  }

  
}
