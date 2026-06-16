import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/cart/domain/repositories/cart_repo.dart';
import 'package:nexora/features/cart/presentation/manager/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;
  CartCubit(this.cartRepo) : super(CartInitial());

  Future<void> fetchCart() async {
    emit(CartLoading());

    final result = await cartRepo.getUserCart();
    result.fold(
      (failure) {
        emit(CartError(message: failure.message));
      },
      (cart) {
        emit(CartSuccess(cart: cart));
      },
    );
  }

  Future<void> addToCart(String productId, {int quantity = 1}) async {
    final currentCart =
        state is CartSuccess ? (state as CartSuccess).cart : null;

    final result = await cartRepo.addProductToCart(productId, quantity);

    result.fold(
      (failure) {
        if (currentCart != null) {
          emit(CartActionError(
              cart: currentCart, errorMessage: failure.message));
        } else {
          emit(CartError(message: failure.message));
        }
      },
      (updatedCart) {
        emit(CartActionSuccess(
          cart: updatedCart,
          successMessage: "Item added to cart",
        ));
      },
    );
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    final currentCart = (state as CartSuccess).cart;

    final result =
        await cartRepo.updateCartItemQuantity(cartItemId, newQuantity);

    result.fold(
      (failure) {
        emit(CartActionError(cart: currentCart, errorMessage: failure.message));
      },
      (updatedCart) {
        emit(CartSuccess(cart: updatedCart));
      },
    );
  }

  Future<void> removeCartItem(String cartItemId) async {
    final currentCart = (state as CartSuccess).cart;

    final result = await cartRepo.removeCartItem(cartItemId);

    result.fold(
      (failure) {
        emit(CartActionError(cart: currentCart, errorMessage: failure.message));
      },
      (updatedCart) {
        emit(CartActionSuccess(
          cart: updatedCart,
          successMessage: "Item removed",
        ));
      },
    );
  }

  void clearCart() {
    emit(CartInitial());
  }
}
