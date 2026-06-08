import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/models/category_model.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/widgets/category_card.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  const CategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 24),
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              title: category.name,
              imageUrl: category.image,
              onTap: () {
                context.push(Routes.search, extra: category.name);
              },
            );
          }),
    );
  }
}
