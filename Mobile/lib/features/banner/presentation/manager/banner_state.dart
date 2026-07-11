import 'package:nexora/features/banner/domain/entities/banner.dart';

abstract class BannerState {}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerLoaded extends BannerState {
  final List<PromoBanner> banners;

  BannerLoaded(this.banners);
}

class BannerError extends BannerState {
  final String message;

  BannerError(this.message);
}
