import 'package:coin_saver/features/domain/entities/exchange_rate/rate_entity.dart';

class ExchangeRateEntity {
 final String base;
 final  List<RateEntity> rates;

 const ExchangeRateEntity({required this.base, required this.rates});
}

