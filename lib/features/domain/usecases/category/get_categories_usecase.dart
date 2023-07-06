import 'package:coin_saver/features/domain/entities/account/account_entity.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';
import 'package:coin_saver/features/domain/entities/main_transaction/main_transaction_entity.dart';
import 'package:coin_saver/features/domain/repositories/base_hive_repository.dart';

class GetCategoriesUsecase {
  final BaseHiveRepository repository;
  GetCategoriesUsecase({
    required this.repository,
  });
  Future<List<CategoryEntity>> call() async {
    return repository.getCategories();
  }
}
