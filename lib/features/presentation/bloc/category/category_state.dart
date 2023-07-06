part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoaded extends CategoryState {
 final List<CategoryEntity> categories;
  const CategoryLoaded({
    required this.categories,
  });
  @override
  List<Object> get props => [
        categories,
      ];
}

class CategoryFailure extends CategoryState {
  @override
  List<Object> get props => [];
}
