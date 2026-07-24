import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/product/domain/entities/product.dart';
import 'package:nexora/features/product/domain/repositories/product_repo.dart';

class GetProductByIdUseCase {
  final ProductRepo productRepo;

  GetProductByIdUseCase(this.productRepo);

  Future<Either<Failure, Product>> call(String prodId) async {
    return await productRepo.getProductById(prodId);
  }
}
