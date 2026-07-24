import 'package:nexora/features/brands/domain/entities/brand.dart';

abstract class BrandState {}

class BrandInitial extends BrandState {}

class BrandLoading extends BrandState {}

class BrandLoaded extends BrandState {
  final List<Brand> brands;

  BrandLoaded(this.brands);
}

class BrandError extends BrandState {
  final String message;

  BrandError({required this.message});
}
