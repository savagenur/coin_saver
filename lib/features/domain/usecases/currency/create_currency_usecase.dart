import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class CreateCurrencyUsecase {
  final BaseHiveRepository repository;
  CreateCurrencyUsecase({
    required this.repository,
  });
  Future<void> call(CurrencyEntity currencyEntity ) async {
    return repository.createCurrency(currencyEntity);
  }

  
}
