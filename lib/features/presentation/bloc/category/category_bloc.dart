import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:coin_saver/features/domain/usecases/category/create_category_usecase.dart';
import 'package:coin_saver/features/domain/usecases/category/delete_category_usecase.dart';
import 'package:coin_saver/features/domain/usecases/category/get_categories_usecase.dart';
import 'package:coin_saver/features/domain/usecases/category/update_category_usecase.dart';

import '../../../domain/entities/category/category_entity.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUsecase getCategoriesUsecase;
  final CreateCategoryUsecase createCategoryUsecase;
  final UpdateCategoryUsecase updateCategoryUsecase;
  final DeleteCategoryUsecase deleteCategoryUsecase;

  CategoryBloc({
    required this.getCategoriesUsecase,
    required this.createCategoryUsecase,
    required this.updateCategoryUsecase,
    required this.deleteCategoryUsecase,
  }) : super(CategoryInitial()) {
    on<GetCategories>(_onGetCategories);
    on<CreateCategory>(_onCreateCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  FutureOr<void> _onGetCategories(
      GetCategories event, Emitter<CategoryState> emit) async {
    final List<CategoryEntity> categories = await getCategoriesUsecase.call();
    emit(CategoryLoading());
    emit(CategoryLoaded(categories: categories));
  }

  FutureOr<void> _onCreateCategory(
      CreateCategory event, Emitter<CategoryState> emit) async {
    await createCategoryUsecase.call(event.category);
    final List<CategoryEntity> categories = await getCategoriesUsecase.call();
    emit(CategoryLoading());
    emit(CategoryLoaded(categories: categories));
  }

  FutureOr<void> _onUpdateCategory(
      UpdateCategory event, Emitter<CategoryState> emit) async {
    await updateCategoryUsecase.call( event.category);
    final List<CategoryEntity> categories = await getCategoriesUsecase.call();
    emit(CategoryLoading());
    emit(CategoryLoaded(categories: categories));
    
  }

  FutureOr<void> _onDeleteCategory(
      DeleteCategory event, Emitter<CategoryState> emit) async {
    await deleteCategoryUsecase.call(event.isIncome,event.categoryId,);
    final List<CategoryEntity> categories = await getCategoriesUsecase.call();
    emit(CategoryLoading());
    emit(CategoryLoaded(categories: categories));
  }
}
