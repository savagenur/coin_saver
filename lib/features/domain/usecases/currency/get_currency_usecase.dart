import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class GetCurrencyUsecase {
  final BaseHiveRepository repository;
  GetCurrencyUsecase({
    required this.repository,
  });
  Future<CurrencyEntity> call() async {
    return repository.getCurrency();
  }

  
}
