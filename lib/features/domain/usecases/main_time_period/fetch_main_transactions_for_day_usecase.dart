import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

import '../../entities/main_transaction/main_transaction_entity.dart';

class FetchMainTransactionsForDayUsecase {
  final BaseHiveRepository repository;
  FetchMainTransactionsForDayUsecase({
    required this.repository,
  });

  List<MainTransactionEntity> call(
      DateTime selectedDate, List<MainTransactionEntity> totalMainTransactions) {
    return repository.fetchMainTransactionsForDay(selectedDate, totalMainTransactions);
  }
}
