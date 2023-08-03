import 'package:coin_saver/features/domain/entities/settings/settings_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class GetSettingsUsecase {
  final BaseHiveRepository repository;
  GetSettingsUsecase({
    required this.repository,
  });
  Future<SettingsEntity> call() async =>
      repository.getSettings();
}
