import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/models/category_model.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/widgets/category_card.dart';
import 'package:nexora/features/category/manager/category_cubit.dart';
import 'package:nexora/features/category/manager/category_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(builder: (context, state) {
      if (state is CategoryError) {
        return SizedBox(
          height: 80,
          child: Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      }
      final bool isLoading =
          state is CategoryLoading || state is CategoryInitial;

      final List<Category> categories = isLoading
          ? List.generate(
              6,
              (index) => Category(
                id: index.toString(),
                name: 'Loading..',
                image: '',
              ),
            )
          : (state as CategorySuccess).categories;

      return Skeletonizer(
        enabled: isLoading,
        child: SizedBox(
          height: 80,
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
                    if (!isLoading) {
                      context.push(Routes.search, extra: category.name);
                    }
                  },
                );
              }),
        ),
      );
    });
  }
}
