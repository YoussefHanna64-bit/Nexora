import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/category/domain/usecases/get_categories_use_case.dart';
import 'package:nexora/features/category/presentation/manager/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoryCubit(this.getCategoriesUseCase) : super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());

    final result = await getCategoriesUseCase();

    result.fold(
      (failure) {
        emit(CategoryError(message: failure.message));
      },
      (categories) {
        emit(CategorySuccess(categories: categories));
      },
    );
  }
}
