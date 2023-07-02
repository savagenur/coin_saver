part of 'currency_bloc.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class GetCurrency extends CurrencyEvent {
  
  @override
  List<Object> get props => [
  ];
}

class CreateCurrency extends CurrencyEvent {
  final CurrencyEntity currency;
  const CreateCurrency({
    required this.currency,
  });
  @override
  List<Object> get props => [
    currency,
  ];
}

class UpdateCurrency extends CurrencyEvent {
  final CurrencyEntity currency;
  const UpdateCurrency({
    required this.currency,
  });
  @override
  List<Object> get props => [
    currency,
  ];
}
