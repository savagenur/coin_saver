import 'package:equatable/equatable.dart';

class CurrencyEntity extends Equatable {
  final String code;
  final String name;
  final String symbol;

  const CurrencyEntity({
    required this.code,
    required this.name,
    required this.symbol,
  });

  @override
  List<Object?> get props => [code, name, symbol];
  CurrencyEntity copyWith({
    String? code,
    String? name,
    String? symbol,
  }) {
    return CurrencyEntity(
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
    );
  }
}
