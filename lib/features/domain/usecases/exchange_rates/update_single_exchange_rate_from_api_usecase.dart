import 'package:coin_saver/features/domain/repositories/base_currency_repository.dart';


class UpdateSingleExchangeRateFromApiUsecase {
  final BaseCurrencyRepository repository;
  UpdateSingleExchangeRateFromApiUsecase({
    required this.repository,
  });
  Future<void> call(String baseCurrency) async {
    return repository.updateSingleExchangeRateFromApi(baseCurrency);
  }
}
