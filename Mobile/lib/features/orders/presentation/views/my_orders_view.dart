import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/widgets/custom_empty_state.dart';
import 'package:nexora/core/widgets/custom_error_widget.dart';
import 'package:nexora/core/utils/mock_data.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';
import 'package:nexora/features/orders/presentation/manager/order_history/order_history_cubit.dart';
import 'package:nexora/features/orders/presentation/manager/order_history/order_history_state.dart';
import 'package:nexora/features/orders/presentation/widgets/order_list_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({super.key});

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  @override
  void initState() {
    super.initState();
    context.read<OrderHistoryCubit>().fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: CustomAppBar(title: l10n.myOrders, showBackButton: true),
        body: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
            builder: (context, state) {
          if (state is OrderHistoryError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<OrderHistoryCubit>().fetchOrders();
              },
            );
          }

          final bool isLoading = state is OrderHistoryLoading;

          final List<Order> orders = isLoading
              ? MockData.orders
              : (state is OrderHistoryLoaded ? state.orders : []);

          if (!isLoading && orders.isEmpty) {
            return CustomEmptyState(
              icon: AppIcons.shoppingBagOutlined,
              title: l10n.noOrdersYet,
              subtitle: l10n.noOrdersSubtitle,
              buttonText: l10n.startShopping,
              onButtonPressed: () => context.go(Routes.home),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<OrderHistoryCubit>().fetchOrders();
            },
            color: AppColors.primary,
            child: Skeletonizer(
              enabled: isLoading,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderListItem(
                    order: order,
                    onTap: isLoading
                        ? () {}
                        : () {
                            context.push(Routes.orderDetails, extra: order);
                          },
                  );
                },
              ),
            ),
          );
        }));
  }
}
