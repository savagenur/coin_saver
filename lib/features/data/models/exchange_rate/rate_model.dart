import 'package:coin_saver/features/domain/entities/exchange_rate/rate_entity.dart';
import 'package:hive/hive.dart';
part 'rate_model.g.dart';

@HiveType(typeId: 11)
class RateModel extends RateEntity {
  @HiveField(0)
  final String rateName;
  @HiveField(1)
  final double rate;
  RateModel({
    required this.rateName,
    required this.rate,
  }) : super(
          rate: rate,
          rateName: rateName,
        );

  RateEntity toEntity() {
    return RateEntity(rateName: rateName, rate: rate);
  }
}
