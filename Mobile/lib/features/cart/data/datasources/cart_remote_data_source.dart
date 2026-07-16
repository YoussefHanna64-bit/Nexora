import 'package:nexora/core/models/cart_model.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getUserCart();
  Future<CartModel> addProductToCart(String productId, int quantity);
  Future<CartModel> updateCartItemQuantity(String cartItemId, int quantity);
  Future<CartModel> removeCartItem(String cartItemId);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService apiService;

  CartRemoteDataSourceImpl(this.apiService);

  @override
  Future<CartModel> getUserCart() async {
    final response = await apiService.get(EndPoints.cart);
    return getCart(response.data);
  }

  @override
  Future<CartModel> addProductToCart(String productId, int quantity) async {
    final response = await apiService.post(
      EndPoints.cart,
      body: {"productId": productId, "quantity": quantity},
    );

    return getCart(response.data);
  }

  @override
  Future<CartModel> updateCartItemQuantity(
      String cartItemId, int quantity) async {
    final response = await apiService.patch(
      "${EndPoints.cart}/$cartItemId",
      body: {"quantity": quantity},
    );

    return getCart(response.data);
  }

  @override
  Future<CartModel> removeCartItem(String cartItemId) async {
    final response = await apiService.delete("${EndPoints.cart}/$cartItemId");
    return getCart(response.data);
  }

  @override
  Future<void> clearCart() async {
    await apiService.delete(EndPoints.cart);
  }

  CartModel getCart(Map<String, dynamic> response) {
    return CartModel.fromJson(response["data"]["cart"]);
  }
}
