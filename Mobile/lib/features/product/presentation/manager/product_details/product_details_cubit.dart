import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/product/domain/usecases/get_product_by_id_use_case.dart';
import 'package:nexora/features/product/presentation/manager/product_details/product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductDetailsCubit(this.getProductByIdUseCase)
      : super(ProductDetailsInitial());

  Future<void> fetchProduct(String prodId) async {
    emit(ProductDetailsLoading());

    final result = await getProductByIdUseCase(prodId);

    result.fold(
      (failure) {
        emit(ProductDetailsError(failure.message));
      },
      (product) {
        emit(ProductDetailsLoaded(product));
      },
    );
  }
}
