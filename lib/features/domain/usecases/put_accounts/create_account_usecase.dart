import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class PutAccountsUsecase {
  final BaseHiveRepository repository;
  PutAccountsUsecase({
    required this.repository,
  });
  Future<void> call(List<AccountEntity> accounts) async {
    return repository.putAccounts(accounts);
  }

  
}
