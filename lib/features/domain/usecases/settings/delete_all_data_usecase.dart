import '../../repositories/base_hive_repository.dart';

class DeleteAllDataUsecase {
  final BaseHiveRepository repository;
  DeleteAllDataUsecase({
    required this.repository,
  });
  Future<void> call() async =>
      repository.deleteAllData();
}