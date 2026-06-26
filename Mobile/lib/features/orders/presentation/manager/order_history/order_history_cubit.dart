import 'package:bloc/bloc.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';
import 'package:nexora/features/orders/domain/repositories/order_repo.dart';
import 'package:nexora/features/orders/presentation/manager/order_history/order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final OrderRepo orderRepo;

  OrderHistoryCubit(this.orderRepo) : super(OrderHistoryInitial());

  Future<void> fetchOrders() async {
    emit(OrderHistoryLoading());

    final result = await orderRepo.getUserOrders();

    result.fold(
      (failure) {
        emit(OrderHistoryError(message: failure.message));
      },
      (orders) {
        emit(OrderHistoryLoaded(orders: orders));
      },
    );
  }

  Future<void> cancelOrder(String orderId) async {
    List<Order> currentOrders = [];

    if (state is OrderHistoryLoaded) {
      currentOrders = (state as OrderHistoryLoaded).orders;
    }

    emit(OrderHistoryLoading());

    final result = await orderRepo.cancelOrder(orderId);

    result.fold(
      (failure) => emit(OrderHistoryError(message: failure.message)),
      (updatedOrder) {
        if (currentOrders.isNotEmpty) {
          final newOrdersList = currentOrders.map((order) {
            return order.id == updatedOrder.id ? updatedOrder : order;
          }).toList();

          emit(OrderHistoryLoaded(orders: newOrdersList));
        } else {
          fetchOrders();
        }
      },
    );
  }
}
