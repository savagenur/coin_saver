import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

import '../../entities/category/category_entity.dart';

class UpdateCategoryUsecase {
  final BaseHiveRepository repository;
  UpdateCategoryUsecase({
    required this.repository,
  });
  Future<void> call(CategoryEntity categoryEntity) async {
    return repository.updateCategory(categoryEntity);
  }

  
}
