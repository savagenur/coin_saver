import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

import '../../entities/main_transaction/main_transaction_entity.dart';

class GetMainTransactionsForTodayUsecase {
  final BaseHiveRepository repository;
  GetMainTransactionsForTodayUsecase({
    required this.repository,
  });

  List<MainTransactionEntity> call() {
    return repository.getMainTransactionsForToday();
  }
}
