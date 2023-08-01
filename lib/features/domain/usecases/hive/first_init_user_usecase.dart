import 'package:coin_saver/features/data/datasources/local_datasource/hive/base_hive_local_data_source.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';

class FirstInitUserUsecase {
  final BaseHiveLocalDataSource repository;
  FirstInitUserUsecase({
    required this.repository,
  });

  Future<void> call(CurrencyEntity currencyEntity) async {
    return repository.firstInitUser(currencyEntity);
  }
}
