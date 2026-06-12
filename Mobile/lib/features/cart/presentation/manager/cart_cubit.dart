import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/models/cart_model.dart';
import 'package:nexora/features/cart/presentation/manager/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final List<CartItemModel> items = [];

  void addToCart(Product product, {int quantity = 1}) {
    final itemIndex = items.indexWhere((item) => item.product.id == product.id);

    if (itemIndex >= 0) {
      items[itemIndex].quantity += quantity;
    } else {
      items.add(CartItemModel(product: product, quantity: quantity));
    }

    emitUpdatedState("Item added to cart");
  }

  void removeFromCart(String productId) {
    items.removeWhere((item) => item.product.id == productId);
    emitUpdatedState();
  }

  void incrementQuantity(String productId) {
    final item = items.firstWhere((item) => item.product.id == productId);
    item.quantity++;
    emitUpdatedState();
  }

  void decrementQuantity(String productId) {
    final item = items.firstWhere((item) => item.product.id == productId);
    if (item.quantity > 1) {
      item.quantity--;
      emitUpdatedState();
    }
  }

  void emitUpdatedState([String? successMessage]) {
    emit(CartUpdated(
        successMessage: successMessage,
        cart: CartModel(
            items: List.from(items),
            totalPrice: items.fold(0,
                (sum, item) => sum + (item.product.price * item.quantity)))));
  }

  void clearCart() {
    emit(CartInitial());
  }
}
