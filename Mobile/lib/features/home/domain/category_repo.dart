import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/models/category_model.dart';

abstract class CategoryRepo {
  Future<Either<Failure, List<Category>>> getCategories();
}
