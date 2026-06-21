import 'package:dartz/dartz.dart' hide Order;
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';
import 'package:nexora/features/orders/domain/repositories/order_repo.dart';
import 'package:nexora/features/orders/domain/services/payment_service.dart';

class PlaceOrderUseCase {
  final OrderRepo orderRepo;
  final PaymentService paymentService;

  PlaceOrderUseCase(this.orderRepo, this.paymentService);

  Future<Either<Failure, Order>> call({
    required ShippingAddress shippingAddress,
    required String paymentMethodType,
  }) async {
    if (paymentMethodType == "cash") {
      return orderRepo.createOrder(
        shippingAddress: shippingAddress,
        paymentMethodType: paymentMethodType,
      );
    }

    final intentResult = await orderRepo.createPaymentIntent();
    Failure? intentFailure;
    String? clientSecret;

    intentResult.fold((f) => intentFailure = f, (s) => clientSecret = s);

    if (intentFailure != null) {
      return Left(intentFailure!);
    }

    final paymentResult = await paymentService.processPayment(clientSecret!);
    Failure? paymentFailure;

    paymentResult.fold((f) => paymentFailure = f, (_) {});
    if (paymentFailure != null) {
      return Left(paymentFailure!);
    }

    return orderRepo.createOrder(
      shippingAddress: shippingAddress,
      paymentMethodType: paymentMethodType,
    );
  }
}
