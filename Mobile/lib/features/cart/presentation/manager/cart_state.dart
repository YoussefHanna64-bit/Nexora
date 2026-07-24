import 'package:nexora/features/cart/domain/entities/cart.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final Cart cart;

  CartSuccess({required this.cart});
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});
}

class CartActionSuccess extends CartSuccess {
  final String successMessage;
  CartActionSuccess({required super.cart, required this.successMessage});
}

class CartActionError extends CartSuccess {
  final String errorMessage;
  CartActionError({required super.cart, required this.errorMessage});
}
