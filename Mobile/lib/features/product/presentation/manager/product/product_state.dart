import 'package:nexora/features/product/domain/entities/product.dart';

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

class ProductPaginatedState extends ProductState {
  final List<Product> products;
  final double maxPrice;
  final int currentPage;
  final bool isLoadingMore;
  final bool isReachedMax;
  final Map<String, dynamic> currentFilters;

  ProductPaginatedState({
    required this.products,
    required this.maxPrice,
    required this.currentPage,
    required this.isLoadingMore,
    required this.isReachedMax,
    required this.currentFilters,
  });

  ProductPaginatedState copyWith({
    List<Product>? products,
    double? maxPrice,
    int? currentPage,
    bool? isLoadingMore,
    bool? isReachedMax,
    Map<String, dynamic>? currentFilters,
  }) {
    return ProductPaginatedState(
      products: products ?? this.products,
      maxPrice: maxPrice ?? this.maxPrice,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isReachedMax: isReachedMax ?? this.isReachedMax,
      currentFilters: currentFilters ?? this.currentFilters,
    );
  }
}
