import 'package:bloc/bloc.dart';
import 'package:nexora/features/product/domain/usecases/get_all_products_use_case.dart';
import 'package:nexora/features/product/presentation/manager/product/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProductsUseCase getAllProductsUseCase;

  ProductCubit(this.getAllProductsUseCase) : super(ProductInitial());

  Future<void> fetchProducts({Map<String, dynamic>? queryParameters}) async {
    emit(ProductLoading());

    final result =
        await getAllProductsUseCase(queryParameters: queryParameters);

    result.fold(
      (failure) {
        emit(ProductError(message: failure.message));
      },
      (products) {
        emit(ProductSuccess(
            products: products["products"], maxPrice: products["maxPrice"]));
      },
    );
  }
}
