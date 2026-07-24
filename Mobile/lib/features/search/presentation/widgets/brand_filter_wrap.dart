import 'package:flutter/material.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/features/brands/domain/entities/brand.dart';

class BrandFilterWrap extends StatelessWidget {
  final List<String> selectedBrands;
  final List<Brand> brands;
  final Function(Brand brand, bool isSelected) onBrandSelected;

  const BrandFilterWrap({
    super.key,
    required this.selectedBrands,
    required this.brands,
    required this.onBrandSelected,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: brands.map((brand) {
        final isSelected = selectedBrands.contains(brand.id);

        return FilterChip(
          label: Text(brand.name),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.whiteColor : onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          selectedColor: AppColors.primary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selected: isSelected,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : Theme.of(context).dividerColor,
            ),
          ),
          onSelected: (bool selected) {
            onBrandSelected(brand, selected);
          },
        );
      }).toList(),
    );
  }
}
