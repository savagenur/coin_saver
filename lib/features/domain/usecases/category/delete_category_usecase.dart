import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class DeleteCategoryUsecase {
  final BaseHiveRepository repository;
  DeleteCategoryUsecase({
    required this.repository,
  });
  Future<void> call(int index ) async {
    return repository.deleteCategory(index);
  }

  
}
