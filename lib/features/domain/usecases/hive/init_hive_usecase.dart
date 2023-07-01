import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class InitHiveUsecase {
  final BaseHiveRepository repository;
  InitHiveUsecase({
    required this.repository,
  });
  Future<void> call() async {
    return repository.initHive();
  }
}
