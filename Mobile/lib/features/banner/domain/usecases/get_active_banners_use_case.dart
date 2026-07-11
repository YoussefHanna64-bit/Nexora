import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/banner/domain/entities/banner.dart';
import 'package:nexora/features/banner/domain/repositories/banner_repo.dart';

class GetActiveBannersUseCase {
  final BannerRepo bannerRepo;

  GetActiveBannersUseCase(this.bannerRepo);

  Future<Either<Failure, List<PromoBanner>>> call() {
    return bannerRepo.getActiveBanners();
  }
}
