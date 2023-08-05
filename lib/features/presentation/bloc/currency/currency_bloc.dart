import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/usecases/currency/get_currency_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/currency/currency_entity.dart';
import '../../../domain/usecases/currency/create_currency_usecase.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final GetCurrencyUsecase getCurrencyUsecase;
  final CreateCurrencyUsecase createCurrencyUsecase;
  CurrencyBloc(
      {required this.getCurrencyUsecase, required this.createCurrencyUsecase})
      : super(CurrencyLoading()) {
    on<GetCurrency>(_onGetCurrency);
    on<CreateCurrency>(_onCreateCurrency);
  }

  FutureOr<void> _onGetCurrency(
      GetCurrency event, Emitter<CurrencyState> emit) async {
    final currency = await getCurrencyUsecase.call();
    emit(CurrencyLoaded(currency: currency));
  }

  FutureOr<void> _onCreateCurrency(
      CreateCurrency event, Emitter<CurrencyState> emit) async {
    await createCurrencyUsecase.call(event.currency);
  }
}
