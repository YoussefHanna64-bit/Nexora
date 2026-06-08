import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/models/category_model.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_bottom_sheet_container.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/features/search/presentation/widgets/category_filter_wrap.dart';
import 'package:nexora/features/search/presentation/widgets/price_range_slider.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  RangeValues currentPriceRange = const RangeValues(10, 500);
  final List<String> selectedCategories = [];

  void clearFilters() {
    setState(() {
      currentPriceRange = const RangeValues(10, 500);
      selectedCategories.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    var h = MediaQuery.of(context).size.height;

    return CustomBottomSheetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.filter,
                  style: AppTextStyles.bold20White.copyWith(color: onSurface)),
              TextButton(
                onPressed: clearFilters,
                child: Text(l10n.clearAll, style: AppTextStyles.bold14Primary),
              ),
            ],
          ),
          SizedBox(height: h * 0.02),
          Text(l10n.priceRange,
              style: AppTextStyles.bold14Black.copyWith(color: onSurface)),
          SizedBox(height: h * 0.02),
          PriceRangeSlider(
            max: 1000,
            currentRange: currentPriceRange,
            onChanged: (values) {
              setState(() => currentPriceRange = values);
            },
          ),
          SizedBox(height: h * 0.02),
          Text(l10n.categories,
              style: AppTextStyles.bold14Black.copyWith(color: onSurface)),
          SizedBox(height: h * 0.02),
          // CategoryFilterWrap(
          //   selectedCategories: selectedCategories,
          //   categories: dummyCategories,
          //   onCategorySelected: (category, isSelected) {
          //     setState(() {
          //       if (isSelected) {
          //         selectedCategories.add(category);
          //       } else {
          //         selectedCategories.remove(category);
          //       }
          //     });
          //   },
          // ),
          SizedBox(height: h * 0.02),
          CustomPrimaryButton(
            buttonText: l10n.applyFilters,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
