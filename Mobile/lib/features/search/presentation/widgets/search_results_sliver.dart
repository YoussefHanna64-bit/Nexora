import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/utils/mock_data.dart';
import 'package:nexora/core/widgets/custom_empty_state.dart';
import 'package:nexora/features/product/presentation/widgets/product_grid.dart';
import 'package:nexora/features/product/presentation/manager/product/product_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchResultsSliver extends StatelessWidget {
  final ProductState state;
  final double horizontalPadding;
  final double verticalPadding;

  const SearchResultsSliver({
    super.key,
    required this.state,
    required this.horizontalPadding,
    required this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final bool isInitialLoading =
        state is ProductLoading || state is ProductInitial;

    final List displayProducts;
    final int totalCount;
    final bool isLoadingMore;

    if (isInitialLoading) {
      displayProducts = MockData.products;
      totalCount = 0;
      isLoadingMore = false;
    } else {
      final s = state as ProductPaginatedState;
      displayProducts = s.products;
      totalCount = s.products.length;
      isLoadingMore = s.isLoadingMore;
    }

    return SliverMainAxisGroup(slivers: [
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: Skeletonizer(
            enabled: isInitialLoading,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.results,
                    style:
                        AppTextStyles.bold14Black.copyWith(color: onSurface)),
                Text(
                  isInitialLoading ? "" : l10n.countFound(totalCount),
                  style: AppTextStyles.regular14Grey,
                ),
              ],
            ),
          ),
        ),
      ),
      if (!isInitialLoading && displayProducts.isEmpty)
        SliverFillRemaining(
          child: CustomEmptyState(
            icon: AppIcons.search,
            title: l10n.noProductsFound,
            subtitle: l10n.noProductsFoundSubtitle,
          ),
        )
      else ...[
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: Skeletonizer.sliver(
            enabled: isInitialLoading,
            child: ProductGrid(
              products: List<dynamic>.from(displayProducts).cast(),
              asSliver: true,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isLoadingMore
                ? const Padding(
                    key: ValueKey("loader"),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : const SizedBox(key: ValueKey("spacer"), height: 24),
          ),
        ),
      ],
    ]);
  }
}
