import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class DeleteCategoryUsecase {
  final BaseHiveRepository repository;
  DeleteCategoryUsecase({
    required this.repository,
  });
  Future<void> call(bool isIncome,String categoryId ) async {
    return repository.deleteCategory( isIncome,categoryId);
  }

  
}
