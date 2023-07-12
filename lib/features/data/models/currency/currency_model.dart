import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:coin_saver/features/domain/entities/currency/currency_entity.dart';

part 'currency_model.g.dart';

@HiveType(typeId: 3)
class CurrencyModel extends CurrencyEntity  {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String symbol;

  const CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
  }) : super(code: code, name: name, symbol: symbol);

  @override
  List<Object?> get props => [code, name, symbol];

  CurrencyModel copyWith({
    String? code,
    String? name,
    String? symbol,
  }) {
    return CurrencyModel(
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
    );
  }
  CurrencyEntity toEntity() {
    return CurrencyEntity(code: code, name: name, symbol: symbol);
  }

  static CurrencyModel fromEntity(CurrencyEntity entity) {
    return CurrencyModel(code: entity.code, name: entity.name, symbol: entity.symbol);
  }
}
