import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class UpdateTransactionUsecase {
  final BaseHiveRepository repository;
  UpdateTransactionUsecase({
    required this.repository,
  });

  Future<void> call(
    AccountEntity accountEntity,
    TransactionEntity transactionEntity,
  ) {
    return repository.updateTransaction(
      transactionEntity: transactionEntity,
      accountEntity: accountEntity,
    );
  }
}
