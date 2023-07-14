import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class InitHiveAdaptersBoxesUsecase {
  final BaseHiveRepository repository;
  InitHiveAdaptersBoxesUsecase({
    required this.repository,
  });
  Future<void> call() async {
    return repository.initHiveAdaptersBoxes();
  }
}
