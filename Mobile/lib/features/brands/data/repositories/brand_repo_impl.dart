import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/features/brands/domain/entities/brand.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/brands/data/datasources/brand_remote_data_source.dart';
import 'package:nexora/features/brands/domain/repositories/brand_repo.dart';

class BrandRepoImpl implements BrandRepo {
  final BrandRemoteDataSource remoteDataSource;

  BrandRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Brand>>> getBrands() async {
    try {
      final brands = await remoteDataSource.getBrands();

      return Right(brands);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
