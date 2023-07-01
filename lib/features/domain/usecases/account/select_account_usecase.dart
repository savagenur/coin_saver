import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class SelectAccountUsecase {
  final BaseHiveRepository repository;
  SelectAccountUsecase({
    required this.repository,
  });
  Future<void> call(
      AccountEntity accountEntity, List<AccountEntity> accounts) async {
    return repository.selectAccount(accountEntity, accounts);
  }
}
