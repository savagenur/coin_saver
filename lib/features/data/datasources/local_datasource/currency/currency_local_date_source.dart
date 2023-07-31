import 'dart:convert';

import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/data/datasources/local_datasource/currency/base_currency_local_data_source.dart';
import 'package:coin_saver/features/data/models/currency/currency_model.dart';
import 'package:coin_saver/features/data/models/exchange_rate/exchange_rate_model.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class CurrencyLocalDataSource implements BaseCurrencyLocalDataSource {
  final Box<ExchangeRateModel> exchangeRatesBox =
      Hive.box<ExchangeRateModel>(BoxConst.exchangeRates);
  final Box<CurrencyModel> currencyBox =
      Hive.box<CurrencyModel>(BoxConst.currency);
  @override
  Future<List<ExchangeRateModel>> getExchangeRatesFromAssets() async {
    String manifestContent = await rootBundle.loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = jsonDecode(manifestContent);
    List<ExchangeRateModel> exchangeRates = [];
    try {
      List<String> assetPaths = manifestMap.keys
          .where((String key) =>
              key.startsWith('assets/currencies/') && key.endsWith('.json'))
          .toList();

      await Future.wait(assetPaths.map((assetPath) async {
        String jsonString = await rootBundle.loadString(assetPath);
        Map<String, dynamic> jsonData = jsonDecode(jsonString);
        ExchangeRateModel exchangeRate =
            ExchangeRateModel.fromJsonAssets(jsonData);
        exchangeRates.add(exchangeRate);
      }));
    } catch (e) {
      print('Error loading exchange rates: $e');
    }

    return exchangeRates;
  }

  @override
  Future<List<ExchangeRateModel>> getExchangeRatesFromApi() async {
    final List<ExchangeRateModel> exchangeRates = [];
    // final currencyModels = currencyBox.values.cast<CurrencyModel>().toList();
    // final currencies =
    //     currencyModels.map((currency) => currency.code).join(",");
    // const String apiKey = "fca_live_ZLuN9MN7MVESNdBD9YUGcqljQnOJDs2AwzFfgTc4";

    // await Future.wait(currencyModels.map((currencyModel) async {
    //   final baseCurrency = currencyModel.code;
    //   final url =
    //       "https://api.freecurrencyapi.com/v1/latest?apikey=$apiKey&base_currency=$baseCurrency&currencies=$currencies";
    //   final response = await http.get(Uri.parse(url));
    //   if (response.statusCode == 200) {
    //     final body = json.decode(response.body);
    //     exchangeRates.add(ExchangeRateModel.fromJsonApi(body, baseCurrency));
    //   }
    // }));
    // print(exchangeRates);
    return exchangeRates;
  }

  @override
  double convertCurrency(String base, String desired)  {
    var exchangeRates =
        exchangeRatesBox.values.cast<ExchangeRateModel>().toList();
    var exchangeRate =
        exchangeRates.firstWhere((element) => element.base == base);
    var rateModel =
        exchangeRate.rates.firstWhere((element) => element.rateName == desired);
    return rateModel.rate;
  }
}