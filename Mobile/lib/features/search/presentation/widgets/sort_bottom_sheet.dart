import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/features/product/presentation/manager/product/product_cubit.dart';
import 'package:nexora/features/product/presentation/manager/product/product_state.dart';

class SortBottomSheet {
  SortBottomSheet._();

  static void show(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ProductCubit>();

    final sortOptions = [
      (l10n.popular, {"sort": "-sold"}),
      (l10n.newest, {"sort": "-createdAt"}),
      (l10n.priceLowToHigh, {"sort": "price"}),
      (l10n.priceHighToLow, {"sort": "-price"}),
      (l10n.onSale, {"sort": "-discount"}),
    ];

    final currentState = cubit.state;
    final currentSort = currentState is ProductPaginatedState
        ? currentState.currentFilters["sort"]
        : null;

    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) {
          return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    l10n.sortBy,
                    style: AppTextStyles.bold16Black.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                ...sortOptions.map((entry) {
                  final (label, params) = entry;
                  final isSelected = currentSort == params["sort"];

                  return ListTile(
                    title: Text(
                      label,
                      style: AppTextStyles.bold14Black.copyWith(
                        color: isSelected ? AppColors.primary : null,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(AppIcons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      context.pop();
                      cubit.applySortOrder(params);
                    },
                  );
                }),
              ]);
        });
  }
}
