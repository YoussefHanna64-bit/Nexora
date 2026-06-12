import 'package:bloc/bloc.dart';
import 'package:nexora/features/product/domain/repositories/product_repo.dart';
import 'package:nexora/features/product/presentation/manager/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo productRepo;

  ProductCubit(this.productRepo) : super(ProductInitial());

  Future<void> fetchProducts({Map<String, dynamic>? queryParameters}) async {
    emit(ProductLoading());

    final result =
        await productRepo.getAllProducts(queryParameters: queryParameters);

    result.fold(
      (failure) {
        emit(ProductError(message: failure.message));
      },
      (products) {
        emit(ProductSuccess(products: products));
      },
    );
  }
}
