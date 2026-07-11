import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/banner/domain/entities/banner.dart';

abstract class BannerRepo {
  Future<Either<Failure, List<PromoBanner>>> getActiveBanners();
}
