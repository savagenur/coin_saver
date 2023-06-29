import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class UpdateAccountUsecase {
  final BaseHiveRepository repository;
  UpdateAccountUsecase({
    required this.repository,
  });
  Future<void> call(AccountEntity accountEntity) async {
    return repository.updateAccount(accountEntity);
  }

  
}
