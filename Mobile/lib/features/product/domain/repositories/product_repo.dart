import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/models/product_model.dart';

abstract class ProductRepo {
  Future<Either<Failure, List<Product>>> getAllProducts();
}
