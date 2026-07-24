import 'package:dartz/dartz.dart';
import 'package:nexora/features/category/domain/entities/category.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/category/domain/repositories/category_repo.dart';

class GetCategoriesUseCase {
  final CategoryRepo categoryRepo;

  GetCategoriesUseCase(this.categoryRepo);

  Future<Either<Failure, List<Category>>> call() async {
    return await categoryRepo.getCategories();
  }
}
