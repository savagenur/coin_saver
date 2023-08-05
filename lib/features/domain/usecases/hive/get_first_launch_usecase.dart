import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class GetFirstLaunchUsecase {
  final BaseHiveRepository repository;
  GetFirstLaunchUsecase({
    required this.repository,
  });
  bool call() {
    return repository.getFirstLaunch();
  }
}
