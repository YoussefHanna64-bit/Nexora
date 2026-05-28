import 'package:flutter/material.dart';
import 'package:nexora/core/models/category_model.dart';
import 'package:nexora/core/theme/colors.dart';

class CategoryFilterWrap extends StatelessWidget {
  final List<String> selectedCategories;
  final List<CategoryModel> categories;
  final Function(String category, bool isSelected) onCategorySelected;

  const CategoryFilterWrap(
      {super.key,
      required this.selectedCategories,
      required this.categories,
      required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: categories.map((category) {
        final isSelected = selectedCategories.contains(category.title);

        return FilterChip(
          label: Text(category.title),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : onSurface,
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
            onCategorySelected(category.title, selected);
          },
        );
      }).toList(),
    );
  }
}
