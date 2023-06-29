import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class DeleteAccountUsecase {
  final BaseHiveRepository repository;
  DeleteAccountUsecase({
    required this.repository,
  });
  Future<void> call(String id) async {
    return repository.deleteAccount(id);
  }

  
}
