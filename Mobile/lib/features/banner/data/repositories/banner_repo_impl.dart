import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/banner/data/datasources/banner_remote_data_source.dart';
import 'package:nexora/features/banner/data/models/banner_model.dart';
import 'package:nexora/features/banner/domain/entities/banner.dart';
import 'package:nexora/features/banner/domain/repositories/banner_repo.dart';

class BannerRepoImpl implements BannerRepo {
  final BannerRemoteDataSource remoteDataSource;

  BannerRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PromoBanner>>> getActiveBanners() async {
    try {
      final json = await remoteDataSource.getActiveBanners();

      final List<BannerModel> banners = (json["data"]["addresses"] as List)
          .map((b) => BannerModel.fromJson(b as Map<String, dynamic>))
          .toList();

      return Right(banners);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
