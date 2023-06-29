import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class GetAccountsUsecase {
  final BaseHiveRepository repository;
  GetAccountsUsecase({
    required this.repository,
  });
  Future<List<AccountEntity>> call() async {
    return repository.getAccounts();
  }

  
}
