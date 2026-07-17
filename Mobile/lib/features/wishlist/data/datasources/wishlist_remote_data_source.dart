import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class WishlistRemoteDataSource {
  Future<List<ProductModel>> getUserWishlist();
  Future<List<ProductModel>> toggleWishlist(String productId);
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiService apiService;

  WishlistRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<ProductModel>> getUserWishlist() async {
    final response = await apiService.get(EndPoints.wishlist);

    return getWishlist(response.data);
  }

  @override
  Future<List<ProductModel>> toggleWishlist(String productId) async {
    final response = await apiService.post(
      "${EndPoints.wishlist}/$productId",
    );

    return getWishlist(response.data);
  }

  List<ProductModel> getWishlist(Map<String, dynamic> response) {
    final List<dynamic> ordersList = response["data"]["wishlist"] ?? [];

    return ordersList.map((or) => ProductModel.fromJson(or)).toList();
  }
}
