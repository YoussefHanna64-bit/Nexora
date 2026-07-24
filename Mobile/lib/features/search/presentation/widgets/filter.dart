import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/utils/mock_data.dart';
import 'package:nexora/features/category/domain/entities/category.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_error_widget.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/features/brands/domain/entities/brand.dart';
import 'package:nexora/features/brands/presentation/manager/brand_cubit.dart';
import 'package:nexora/features/brands/presentation/manager/brand_state.dart';
import 'package:nexora/features/category/presentation/manager/category_cubit.dart';
import 'package:nexora/features/category/presentation/manager/category_state.dart';
import 'package:nexora/features/search/presentation/widgets/brand_filter_wrap.dart';
import 'package:nexora/features/search/presentation/widgets/category_filter_wrap.dart';
import 'package:nexora/features/search/presentation/widgets/price_range_slider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Filter extends StatefulWidget {
  final RangeValues? initialPriceRange;
  final String? initialCategoryId;
  final String? initialBrandId;
  final double maxPrice;
  const Filter(
      {super.key,
      this.initialPriceRange,
      this.initialCategoryId,
      this.initialBrandId,
      this.maxPrice = 2000});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  late RangeValues currentPriceRange;
  final List<String> selectedCategories = [];
  final List<String> selectedBrands = [];

  @override
  void initState() {
    super.initState();
    currentPriceRange =
        widget.initialPriceRange ?? RangeValues(10, widget.maxPrice);

    if (widget.initialCategoryId != null) {
      selectedCategories.add(widget.initialCategoryId!);
    }

    if (widget.initialBrandId != null && widget.initialBrandId!.isNotEmpty) {
      selectedBrands.addAll(widget.initialBrandId!.split(","));
    }
  }

  void clearFilters() {
    setState(() {
      currentPriceRange = RangeValues(10, widget.maxPrice);
      selectedCategories.clear();
      selectedBrands.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    var h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.filter,
                    style:
                        AppTextStyles.bold20White.copyWith(color: onSurface)),
                TextButton(
                  onPressed: clearFilters,
                  child:
                      Text(l10n.clearAll, style: AppTextStyles.bold14Primary),
                ),
              ],
            ),
            SizedBox(height: h * 0.02),
            Text(l10n.priceRange,
                style: AppTextStyles.bold14Black.copyWith(color: onSurface)),
            SizedBox(height: h * 0.02),
            PriceRangeSlider(
              max: widget.maxPrice,
              currentRange: currentPriceRange,
              onChanged: (values) {
                setState(() => currentPriceRange = values);
              },
            ),
            SizedBox(height: h * 0.02),
            Text(l10n.categories,
                style: AppTextStyles.bold14Black.copyWith(color: onSurface)),
            SizedBox(height: h * 0.02),
            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state is CategoryError) {
                  return CustomErrorWidget(
                    message: state.message,
                    isCompact: true,
                    onRetry: () =>
                        context.read<CategoryCubit>().fetchCategories(),
                  );
                }

                final bool isLoading =
                    state is CategoryLoading || state is CategoryInitial;

                final List<Category> displayCategories = isLoading
                    ? MockData.mockCategories
                    : (state as CategorySuccess).categories;

                return Skeletonizer(
                  enabled: isLoading,
                  child: CategoryFilterWrap(
                    selectedCategories: selectedCategories,
                    categories: displayCategories,
                    onCategorySelected: isLoading
                        ? (category, isSelected) {}
                        : (category, isSelected) {
                            setState(() {
                              if (isSelected) {
                                selectedCategories.clear();
                                selectedCategories.add(category.id);
                              } else {
                                selectedCategories.remove(category.id);
                              }
                            });
                          },
                  ),
                );
              },
            ),
            SizedBox(height: h * 0.02),
            Text(l10n.brands,
                style: AppTextStyles.bold14Black.copyWith(color: onSurface)),
            SizedBox(height: h * 0.02),
            BlocBuilder<BrandCubit, BrandState>(
              builder: (context, state) {
                if (state is BrandError) {
                  return CustomErrorWidget(
                    message: state.message,
                    isCompact: true,
                    onRetry: () => context.read<BrandCubit>().fetchBrands(),
                  );
                }

                final bool isLoading =
                    state is BrandLoading || state is BrandInitial;

                final List<Brand> displayBrands = isLoading
                    ? MockData.mockBrands
                    : (state as BrandLoaded).brands;

                return Skeletonizer(
                  enabled: isLoading,
                  child: BrandFilterWrap(
                    selectedBrands: selectedBrands,
                    brands: displayBrands,
                    onBrandSelected: isLoading
                        ? (brand, isSelected) {}
                        : (brand, isSelected) {
                            setState(() {
                              if (isSelected) {
                                selectedBrands.add(brand.id);
                              } else {
                                selectedBrands.remove(brand.id);
                              }
                            });
                          },
                  ),
                );
              },
            ),
            SizedBox(height: h * 0.02),
            CustomPrimaryButton(
              buttonText: l10n.applyFilters,
              onPressed: () {
                Map<String, dynamic> filters = {
                  "price[gte]": currentPriceRange.start,
                  "price[lte]": currentPriceRange.end,
                };

                if (selectedCategories.isNotEmpty) {
                  filters["category"] = selectedCategories.first;
                }

                if (selectedBrands.isNotEmpty) {
                  filters["brand"] = selectedBrands.join(",");
                }

                Navigator.pop(context, filters);
              },
            ),
          ],
        ),
      ),
    );
  }
}
