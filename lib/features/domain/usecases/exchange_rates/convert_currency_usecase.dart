import 'package:coin_saver/features/domain/repositories/base_currency_repository.dart';

class ConvertCurrencyUsecase {
  final BaseCurrencyRepository repository;
  ConvertCurrencyUsecase({
    required this.repository,
  });
  double call(String base, String desired)  =>
      repository.convertCurrency(base, desired);
}
