import '../../data/models/exchange_rate/exchange_rate_model.dart';

abstract class BaseCurrencyRepository {
  Future<List<ExchangeRateModel>> getExchangeRatesFromAssets();
  Future<List<ExchangeRateModel>> getExchangeRatesFromApi();
}
