import 'package:dartz/dartz.dart';
import 'package:nexora/features/brands/domain/entities/brand.dart';
import 'package:nexora/core/errors/failure.dart';

abstract class BrandRepo {
  Future<Either<Failure, List<Brand>>> getBrands();
}
