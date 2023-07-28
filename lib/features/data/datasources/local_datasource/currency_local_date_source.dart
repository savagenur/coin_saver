import 'dart:convert';

import 'package:coin_saver/features/data/datasources/local_datasource/base_currency_local_data_source.dart';
import 'package:coin_saver/features/data/models/exchange_rate/exchange_rate_model.dart';
import 'package:flutter/services.dart';

class CurrencyLocalDataSource implements BaseCurrencyLocalDataSource{
  
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
        ExchangeRateModel exchangeRate = ExchangeRateModel.fromJson(jsonData);
        exchangeRates.add(exchangeRate);
      }));
    } catch (e) {
      print('Error loading exchange rates: $e');
    }

    return exchangeRates;
  }

  @override
  Future<List<ExchangeRateModel>> getExchangeRatesFromApi() {
    // TODO: implement getExchangeRatesFromApi
    throw UnimplementedError();
  }
}