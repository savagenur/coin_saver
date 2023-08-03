part of 'currency_bloc.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object> get props => [];
}


class CurrencyLoading extends CurrencyState {
  @override
  List<Object> get props => [];
}

class CurrencyLoaded extends CurrencyState {
  final CurrencyEntity currency;
  const CurrencyLoaded({
    required this.currency,
  });
  @override
  List<Object> get props => [
        currency,
      ];
}


