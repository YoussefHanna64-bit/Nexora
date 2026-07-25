import 'package:flutter/material.dart';
import 'package:nexora/features/category/domain/entities/category.dart';
import 'package:nexora/core/theme/colors.dart';

class CategoryFilterWrap extends StatelessWidget {
  final String selectedCategory;
  final List<Category> categories;
  final Function(Category category, bool isSelected) onCategorySelected;

  const CategoryFilterWrap(
      {super.key,
      required this.selectedCategory,
      required this.categories,
      required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: categories.map((category) {
        final isSelected = selectedCategory == category.id;

        return ChoiceChip(
          label: Text(category.name),
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
            onCategorySelected(category, selected);
          },
        );
      }).toList(),
    );
  }
}
