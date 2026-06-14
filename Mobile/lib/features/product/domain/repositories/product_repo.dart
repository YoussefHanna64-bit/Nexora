import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';

abstract class ProductRepo {
  Future<Either<Failure, Map<String, dynamic>>> getAllProducts(
      {Map<String, dynamic>? queryParameters});
}
