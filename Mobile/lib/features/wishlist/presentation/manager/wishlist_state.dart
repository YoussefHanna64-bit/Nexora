import 'package:nexora/features/product/domain/entities/product.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistSuccess extends WishlistState {
  final List<Product> wishlist;

  WishlistSuccess({required this.wishlist});
}

class WishlistError extends WishlistState {
  final String message;

  WishlistError({required this.message});
}
