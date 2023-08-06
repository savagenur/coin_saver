import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

import '../../entities/account/account_entity.dart';

class GetPrimaryAccountUsecase {
  final BaseHiveRepository repository;
  GetPrimaryAccountUsecase({
    required this.repository,
  });
  AccountEntity call() => repository.getPrimaryAccount();
}
