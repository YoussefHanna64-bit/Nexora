import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/features/product/presentation/manager/product/product_cubit.dart';
import 'package:nexora/features/product/presentation/manager/product/product_state.dart';
import 'package:nexora/features/search/presentation/widgets/filter.dart';
import 'package:nexora/features/search/presentation/widgets/sort_bottom_sheet.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Map<String, dynamic> activeFilters;
  final VoidCallback onSearchChanged;
  final ValueChanged<Map<String, dynamic>> onFiltersApplied;

  const SearchAppBar({
    super.key,
    required this.searchController,
    required this.activeFilters,
    required this.onSearchChanged,
    required this.onFiltersApplied,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _openFilter(BuildContext context) async {
    RangeValues? savedPriceRange;
    if (activeFilters.containsKey("price[gte]") &&
        activeFilters.containsKey("price[lte]")) {
      savedPriceRange = RangeValues(
        (activeFilters["price[gte]"] as num).toDouble(),
        (activeFilters["price[lte]"] as num).toDouble(),
      );
    }

    double maxPrice = 10000;
    final currentState = context.read<ProductCubit>().state;
    if (currentState is ProductPaginatedState) {
      maxPrice = currentState.maxPrice;
    }

    final Map<String, dynamic>? filters = await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Filter(
          initialPriceRange: savedPriceRange,
          initialCategoryId: activeFilters["category"],
          initialBrandId: activeFilters["brand"],
          maxPrice: maxPrice,
        );
      },
    );

    if (filters != null) {
      onFiltersApplied(filters);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final w = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(AppIcons.arrowBack, color: onSurface, size: 20),
        onPressed: () => context.pop(),
      ),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                hintText: l10n.search,
                controller: searchController,
                validator: (value) => null,
                autoFocus: searchController.text.isEmpty,
                onChanged: (value) => onSearchChanged(),
              ),
            ),
            SizedBox(width: w * 0.02),
            _IconActionButton(
              icon: AppIcons.sort,
              color: AppColors.primary,
              outlined: true,
              tooltip: l10n.sortBy,
              onPressed: () => SortBottomSheet.show(context),
            ),
            SizedBox(width: w * 0.02),
            _IconActionButton(
              icon: AppIcons.tune,
              color: AppColors.whiteColor,
              backgroundColor: AppColors.primary,
              tooltip: l10n.filter,
              onPressed: () => _openFilter(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? backgroundColor;
  final bool outlined;
  final String? tooltip;
  final VoidCallback onPressed;

  const _IconActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.backgroundColor,
    this.outlined = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: outlined
            ? Border.all(color: AppColors.primary.withAlpha(80))
            : null,
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
