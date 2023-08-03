import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class UpdateThemeUsecase {
  final BaseHiveRepository repository;
  UpdateThemeUsecase({
    required this.repository,
  });
  Future<void> call(bool isDarkTheme) async =>
      repository.updateTheme(isDarkTheme);
}
