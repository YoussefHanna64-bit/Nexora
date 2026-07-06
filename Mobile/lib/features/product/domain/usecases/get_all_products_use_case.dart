import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/product/domain/repositories/product_repo.dart';

class GetAllProductsUseCase {
  final ProductRepo productRepo;

  GetAllProductsUseCase(this.productRepo);

  Future<Either<Failure, Map<String, dynamic>>> call(
      {Map<String, dynamic>? queryParameters}) async {
    return await productRepo.getAllProducts(queryParameters: queryParameters);
  }
}
