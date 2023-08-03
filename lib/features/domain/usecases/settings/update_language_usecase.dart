import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class UpdateLanguageUsecase {
  final BaseHiveRepository repository;
  UpdateLanguageUsecase({
    required this.repository,
  });
  Future<void> call(String language) async =>
      repository.updateLanguage(language);
}
