import 'package:bloc/bloc.dart';
import 'package:nexora/features/product/domain/usecases/get_all_products_use_case.dart';
import 'package:nexora/features/product/presentation/manager/product/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProductsUseCase getAllProductsUseCase;

  ProductCubit(this.getAllProductsUseCase) : super(ProductInitial());

  final int _pageLimit = 10;

  Future<void> fetchProducts({Map<String, dynamic>? queryParameters}) async {
    emit(ProductLoading());

    final result =
        await getAllProductsUseCase(queryParameters: queryParameters);

    result.fold(
      (failure) {
        emit(ProductError(message: failure.message));
      },
      (data) {
        emit(ProductSuccess(
          products: data["products"],
          maxPrice: data["maxPrice"],
        ));
      },
    );
  }

  Future<void> fetchProductsPaginated({
    Map<String, dynamic>? filters,
  }) async {
    final activeFilters = filters ?? {};

    emit(ProductLoading());

    final params = {
      ...activeFilters,
      "page": 1,
      "limit": _pageLimit,
    };

    final result = await getAllProductsUseCase(queryParameters: params);

    result.fold(
      (failure) {
        emit(ProductError(message: failure.message));
      },
      (data) {
        final products = List.of(data["products"] as List);

        emit(ProductPaginatedState(
          products: products.cast(),
          maxPrice: (data["maxPrice"] as num).toDouble(),
          currentPage: 1,
          isLoadingMore: false,
          isReachedMax: products.length < _pageLimit,
          currentFilters: activeFilters,
        ));
      },
    );
  }

  Future<void> fetchMoreProducts() async {
    final current = state;

    if (current is! ProductPaginatedState) {
      return;
    }

    if (current.isLoadingMore || current.isReachedMax) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.currentPage + 1;
    final params = {
      ...current.currentFilters,
      "page": nextPage,
      "limit": _pageLimit,
    };

    final result = await getAllProductsUseCase(queryParameters: params);

    result.fold(
      (failure) {
        emit(current.copyWith(isLoadingMore: false));
      },
      (data) {
        final newProducts = List.of(data["products"] as List).cast();
        emit(current.copyWith(
          products: [...current.products, ...newProducts],
          currentPage: nextPage,
          isLoadingMore: false,
          isReachedMax: newProducts.length < _pageLimit,
        ));
      },
    );
  }

  Future<void> applySortOrder(Map<String, dynamic> sortParams) async {
    final current = state;
    final existingFilters = current is ProductPaginatedState
        ? Map<String, dynamic>.from(current.currentFilters)
        : <String, dynamic>{};

    existingFilters.remove("sort");

    await fetchProductsPaginated(
      filters: {...existingFilters, ...sortParams},
    );
  }
}
