import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/cart/domain/usecases/add_product_to_cart_use_case.dart';
import 'package:nexora/features/cart/domain/usecases/get_user_cart_use_case.dart';
import 'package:nexora/features/cart/domain/usecases/remove_cart_item_use_case.dart';
import 'package:nexora/features/cart/domain/usecases/update_cart_item_quantity_use_case.dart';
import 'package:nexora/features/cart/presentation/manager/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetUserCartUseCase getUserCartUseCase;
  final AddProductToCartUseCase addProductToCartUseCase;
  final UpdateCartItemQuantityUseCase updateCartItemQuantityUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;

  CartCubit(this.getUserCartUseCase, this.addProductToCartUseCase,
      this.updateCartItemQuantityUseCase, this.removeCartItemUseCase)
      : super(CartInitial());

  Future<void> fetchCart() async {
    emit(CartLoading());

    final result = await getUserCartUseCase();

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

    final result = await addProductToCartUseCase(productId, quantity);

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
          successMessage: "itemAddedToCart",
        ));
      },
    );
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    final currentCart = (state as CartSuccess).cart;

    final result = await updateCartItemQuantityUseCase(cartItemId, newQuantity);

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

    final result = await removeCartItemUseCase(cartItemId);

    result.fold(
      (failure) {
        emit(CartActionError(cart: currentCart, errorMessage: failure.message));
      },
      (updatedCart) {
        emit(CartActionSuccess(
          cart: updatedCart,
          successMessage: "itemRemoved",
        ));
      },
    );
  }

  void clearCart() {
    emit(CartInitial());
  }
}
