import 'package:bloc/bloc.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/orders/domain/usecases/place_order_use_case.dart';
import 'package:nexora/features/orders/presentation/manager/checkout/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final PlaceOrderUseCase placeOrderUseCase;

  CheckoutCubit(this.placeOrderUseCase) : super(CheckoutInitial());

  Future<void> processCheckout({
    required ShippingAddress shippingAddress,
    required String paymentMethodType,
  }) async {
    emit(CheckoutLoading());

    final result = await placeOrderUseCase.call(
      shippingAddress: shippingAddress,
      paymentMethodType: paymentMethodType,
    );

    result.fold(
      (failure) {
        emit(CheckoutError(message: failure.message));
      },
      (order) {
        emit(CheckoutSuccess(order: order));
      },
    );
  }
}
