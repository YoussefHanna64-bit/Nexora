import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/product/domain/entities/product.dart';

abstract class ProductRepo {
  Future<Either<Failure, Map<String, dynamic>>> getAllProducts(
      {Map<String, dynamic>? queryParameters});
  Future<Either<Failure, Product>> getProductById(String id);
}
