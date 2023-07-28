import 'package:coin_saver/features/domain/repositories/base_currency_repository.dart';

import '../../../data/models/exchange_rate/exchange_rate_model.dart';

class GetExchangeRatesFromAssets {
  final BaseCurrencyRepository repository;
  GetExchangeRatesFromAssets({
    required this.repository,
  });
  Future<List<ExchangeRateModel>> call() async {
    return repository.getExchangeRatesFromAssets();
  }
}
