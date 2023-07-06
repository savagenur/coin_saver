import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

import '../../entities/category/category_entity.dart';

class CreateCategoryUsecase {
  final BaseHiveRepository repository;
  CreateCategoryUsecase({
    required this.repository,
  });
  Future<void> call(CategoryEntity categoryEntity) async {
    return repository.createCategory(categoryEntity);
  }

  
}
