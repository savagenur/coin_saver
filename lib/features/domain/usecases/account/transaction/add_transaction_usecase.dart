import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/transaction/transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class AddTransactionUsecase {
  final BaseHiveRepository repository;
  AddTransactionUsecase({
    required this.repository,
  });

  Future<void> call(
    AccountEntity accountEntity,
     TransactionEntity transactionEntity,
     bool isIncome,
     double amount,
  ) {
    return repository.addTransaction(
        accountEntity: accountEntity,
        transactionEntity: transactionEntity,
        isIncome: isIncome,
        amount: amount);
  }
}
