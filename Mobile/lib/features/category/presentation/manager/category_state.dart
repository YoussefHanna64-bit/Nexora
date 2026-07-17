import 'package:nexora/core/entities/category.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<Category> categories;

  CategorySuccess({required this.categories});
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError({required this.message});
}
