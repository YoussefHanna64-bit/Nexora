import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class ProductRemoteDataSource {
  Future<Map<String, dynamic>> getAllProducts(
      {Map<String, dynamic>? queryParameters});
  Future<Map<String, dynamic>> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> getAllProducts(
      {Map<String, dynamic>? queryParameters}) async {
    final response = await apiService.get(EndPoints.products,
        queryParameters: queryParameters);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getProductById(String id) async {
    final response = await apiService.get("${EndPoints.products}/$id");
    return response.data;
  }
}
