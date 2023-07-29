import 'package:coin_saver/features/data/datasources/local_datasource/currency/base_currency_local_data_source.dart';
import 'package:coin_saver/features/data/models/exchange_rate/exchange_rate_model.dart';
import 'package:coin_saver/features/domain/repositories/base_currency_repository.dart';

class CurrencyRepository implements BaseCurrencyRepository {
  final BaseCurrencyLocalDataSource currencyLocalDataSource;
  CurrencyRepository({
    required this.currencyLocalDataSource,
  });

  @override
  Future<List<ExchangeRateModel>> getExchangeRatesFromApi() async =>
      currencyLocalDataSource.getExchangeRatesFromApi();

  @override
  Future<List<ExchangeRateModel>> getExchangeRatesFromAssets() async =>
      currencyLocalDataSource.getExchangeRatesFromAssets();

  @override
  double convertCurrency(String base, String desired)  =>
      currencyLocalDataSource.convertCurrency(base, desired);
}
