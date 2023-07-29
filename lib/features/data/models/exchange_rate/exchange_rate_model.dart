import 'package:coin_saver/features/data/models/exchange_rate/rate_model.dart';
import 'package:coin_saver/features/domain/entities/exchange_rate/exchange_rate_entity.dart';
import 'package:hive/hive.dart';
part 'exchange_rate_model.g.dart';

@HiveType(typeId: 10)
class ExchangeRateModel extends ExchangeRateEntity {
  @HiveField(0)
  String base;
  @HiveField(1)
  List<RateModel> rates;

  ExchangeRateModel({required this.base, required this.rates})
      : super(
          base: base,
          rates: rates.map((e) => e.toEntity()).toList(),
        );

  factory ExchangeRateModel.fromJsonAssets(Map<String, dynamic> json) {
    return ExchangeRateModel(
      base: json['base'],
      rates: List<RateModel>.from(json['rates'].entries.map((MapEntry entry) =>
          RateModel(rateName: entry.key, rate: entry.value.toDouble()))),
    );
  }
  factory ExchangeRateModel.fromJsonApi(
      Map<String, dynamic> json, String base) {
    return ExchangeRateModel(
      base: base,
      rates: List<RateModel>.from(json['data'].entries.map((MapEntry entry) =>
          RateModel(rateName: entry.key, rate: entry.value.toDouble()))),
    );
  }
  ExchangeRateEntity toEntity() {
    return ExchangeRateEntity(
        base: base, rates: rates.map((e) => e.toEntity()).toList());
  }

  // static ExchangeRateModel fromEntity(ExchangeRateEntity entity) {
  //   return ExchangeRateModel(base:entity. base, rates: entity. rates);
  // }
}
