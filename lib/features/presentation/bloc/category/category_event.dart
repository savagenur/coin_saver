part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCategories extends CategoryEvent {
  @override
  List<Object> get props => [];
}

class CreateCategory extends CategoryEvent {
  final CategoryEntity category;
  const CreateCategory({
    required this.category,
  });
  @override
  List<Object> get props => [category];
}
class DeleteCategory extends CategoryEvent {
  final String categoryId;
  const DeleteCategory({
    required this.categoryId,
  });
  @override
  List<Object> get props => [categoryId];
}

class UpdateCategory extends CategoryEvent {
  final int index;
  final CategoryEntity category;
  const UpdateCategory({
    required this.index,
    required this.category,
  });
  @override
  List<Object> get props => [index, category];
}
