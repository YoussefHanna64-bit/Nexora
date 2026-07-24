import 'package:dartz/dartz.dart';
import 'package:nexora/features/category/domain/entities/category.dart';
import 'package:nexora/core/errors/failure.dart';

abstract class CategoryRepo {
  Future<Either<Failure, List<Category>>> getCategories();
}
