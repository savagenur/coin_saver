import 'package:bloc/bloc.dart';
import 'package:coin_saver/features/domain/entities/category/category_entity.dart';


class SelectedCategoryCubit extends Cubit<CategoryEntity?> {
  SelectedCategoryCubit() : super(null);

  changeCategory(CategoryEntity? categoryEntity) {
    emit(categoryEntity);
  }
}
