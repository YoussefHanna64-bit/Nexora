import 'package:nexora/core/entities/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<Product> products;
  final double maxPrice;

  ProductSuccess({required this.products, required this.maxPrice});
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});
}
