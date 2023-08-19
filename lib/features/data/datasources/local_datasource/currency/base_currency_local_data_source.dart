
import '../../../models/exchange_rate/exchange_rate_model.dart';

abstract class BaseCurrencyLocalDataSource {
  Future<List<ExchangeRateModel>> getExchangeRatesFromAssets();
  Future<List<ExchangeRateModel>> getExchangeRatesFromApi();
  Future<void> updateSingleExchangeRateFromApi(String baseCurrency);
  double convertCurrency(String base, String desired);
}
