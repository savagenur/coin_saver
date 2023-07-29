import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

import '../../../entities/account/account_entity.dart';
import '../../../entities/transaction/transaction_entity.dart';

class AddTransferUsecase {
  final BaseHiveRepository repository;
  AddTransferUsecase({
    required this.repository,
  });
  Future<void> call({
    required AccountEntity accountFrom,
    required AccountEntity accountTo,
    required TransactionEntity transactionEntity,
  }) async {
    
    return repository.addTransfer(
        accountFrom: accountFrom,
        accountTo: accountTo,
        transactionEntity: transactionEntity);
  }
}
