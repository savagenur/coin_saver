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
  final bool isIncome;
  final String categoryId;
  const DeleteCategory({
    required this.isIncome,
    required this.categoryId,
  });
  @override
  List<Object> get props => [
        categoryId,
        isIncome,
      ];
}

class UpdateCategory extends CategoryEvent {
  final CategoryEntity category;
  const UpdateCategory({
    required this.category,
  });
  @override
  List<Object> get props => [category];
}
