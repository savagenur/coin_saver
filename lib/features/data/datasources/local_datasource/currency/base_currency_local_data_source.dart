
import '../../../models/exchange_rate/exchange_rate_model.dart';

abstract class BaseCurrencyLocalDataSource {
  Future<List<ExchangeRateModel>> getExchangeRatesFromAssets();
  Future<List<ExchangeRateModel>> getExchangeRatesFromApi();
  double convertCurrency(String base, String desired);
}
