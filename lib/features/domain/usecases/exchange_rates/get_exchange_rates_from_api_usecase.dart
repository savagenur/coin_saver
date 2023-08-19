
import 'package:coin_saver/features/domain/repositories/base_currency_repository.dart';

import '../../../data/models/exchange_rate/exchange_rate_model.dart';

class GetExchangeRatesFromApiUsecase {
  final BaseCurrencyRepository repository;
  GetExchangeRatesFromApiUsecase({
    required this.repository,
  });
  Future<List<ExchangeRateModel>> call() async {
    return repository.getExchangeRatesFromApi();
  }
}
