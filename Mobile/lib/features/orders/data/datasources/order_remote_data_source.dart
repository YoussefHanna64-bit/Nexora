import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class OrderRemoteDataSource {
  Future<String> createPaymentIntent();
  Future<Map<String, dynamic>> createOrder(
      Map<String, dynamic> shippingAddress, String paymentMethodType);
  Future<List<Map<String, dynamic>>> getUserOrders();
  Future<Map<String, dynamic>> getOrderById(String orderId);
  Future<Map<String, dynamic>> cancelOrder(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiService apiService;

  OrderRemoteDataSourceImpl(this.apiService);

  @override
  Future<String> createPaymentIntent() async {
    final response = await apiService.post(EndPoints.paymentIntent);
    return response.data["data"]["clientSecret"];
  }

  @override
  Future<Map<String, dynamic>> createOrder(
      Map<String, dynamic> shippingAddress, String paymentMethodType) async {
    final response = await apiService.post(
      EndPoints.orders,
      body: {
        "shippingAddress": shippingAddress,
        "paymentMethodType": paymentMethodType,
      },
    );
    return response.data["data"]["order"];
  }

  @override
  Future<List<Map<String, dynamic>>> getUserOrders() async {
    final response = await apiService.get(EndPoints.myOrders);
    final orders = response.data["data"]["orders"] as List;
    return orders.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    final response = await apiService.get('${EndPoints.orders}/$orderId');
    return response.data["data"]["order"];
  }

  @override
  Future<Map<String, dynamic>> cancelOrder(String orderId) async {
    final response =
        await apiService.patch('${EndPoints.orders}/$orderId/cancel');
    return response.data["data"]["order"];
  }
}
