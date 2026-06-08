import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/home/domain/repositories/category_repo.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepo categoryRepo;

  CategoryCubit(this.categoryRepo) : super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());

    final result = await categoryRepo.getCategories();

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
