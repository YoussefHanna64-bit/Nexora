import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/orders/data/models/order_model.dart';
import 'package:nexora/features/orders/domain/usecases/params/order_params.dart';

abstract class OrderRemoteDataSource {
  Future<String> createPaymentIntent();
  Future<OrderModel> createOrder(CreateOrderParams params);
  Future<List<OrderModel>> getUserOrders();
  Future<OrderModel> getOrderById(String orderId);
  Future<OrderModel> cancelOrder(String orderId);
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
  Future<OrderModel> createOrder(CreateOrderParams params) async {
    final response = await apiService.post(
      EndPoints.orders,
      body: params.toJson(),
    );

    return getOrder(response.data);
  }

  @override
  Future<List<OrderModel>> getUserOrders() async {
    final response = await apiService.get(EndPoints.myOrders);

    return getOrdersList(response.data);
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    final response = await apiService.get('${EndPoints.orders}/$orderId');
    return getOrder(response.data);
  }

  @override
  Future<OrderModel> cancelOrder(String orderId) async {
    final response =
        await apiService.patch('${EndPoints.orders}/$orderId/cancel');
    return getOrder(response.data);
  }

  OrderModel getOrder(Map<String, dynamic> response) {
    return OrderModel.fromJson(response["data"]["order"]);
  }

  List<OrderModel> getOrdersList(Map<String, dynamic> response) {
    final List<dynamic> ordersList = response["data"]["orders"] ?? [];

    return ordersList.map((or) => OrderModel.fromJson(or)).toList();
  }
}
