import 'package:nexora/core/models/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartUpdated extends CartState {
  final Cart cart;
  final String? successMessage;

  CartUpdated({required this.cart, this.successMessage});
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});
}
