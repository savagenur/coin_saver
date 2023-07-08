import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class SetPrimaryAccountUsecase {
  final BaseHiveRepository repository;
  SetPrimaryAccountUsecase({
    required this.repository,
  });
  Future<void> call(String accountId) async {
    return repository.setPrimaryAccount( accountId);
  }
}
