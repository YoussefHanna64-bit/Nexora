import 'package:dartz/dartz.dart';
import 'package:nexora/features/brands/domain/entities/brand.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/brands/domain/repositories/brand_repo.dart';

class GetBrandsUseCase {
  final BrandRepo brandRepo;

  GetBrandsUseCase(this.brandRepo);

  Future<Either<Failure, List<Brand>>> call() {
    return brandRepo.getBrands();
  }
}
