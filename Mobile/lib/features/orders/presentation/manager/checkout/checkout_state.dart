import 'package:nexora/features/orders/domain/entities/order.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final Order order;

  CheckoutSuccess({required this.order});
}

class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError({required this.message});
}
