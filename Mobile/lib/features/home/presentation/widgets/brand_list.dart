import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/utils/mock_data.dart';
import 'package:nexora/features/brands/presentation/presentation/widgets/brand_card.dart';
import 'package:nexora/core/widgets/custom_empty_state.dart';
import 'package:nexora/features/brands/domain/entities/brand.dart';
import 'package:nexora/features/brands/presentation/manager/brand_cubit.dart';
import 'package:nexora/features/brands/presentation/manager/brand_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BrandList extends StatelessWidget {
  const BrandList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandCubit, BrandState>(
      builder: (context, state) {
        if (state is BrandError) {
          return const SizedBox.shrink();
        }

        final bool isLoading = state is BrandLoading || state is BrandInitial;

        if (!isLoading && state is BrandLoaded && state.brands.isEmpty) {
          return CustomEmptyState(
            icon: AppIcons.brokenImage,
            title: "No Brands",
            subtitle: "No brands are available right now",
          );
        }

        final List<Brand> brands =
            isLoading ? MockData.brands : (state as BrandLoaded).brands;

        return Skeletonizer(
          enabled: isLoading,
          child: SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: brands.length,
              separatorBuilder: (context, index) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                final brand = brands[index];
                return BrandCard(
                  name: brand.name,
                  imageUrl: brand.image,
                  onTap: () {
                    if (!isLoading) {
                      context.push(
                        Routes.search,
                        extra: {
                          "query": brand.name,
                          "filters": {"brand": brand.id},
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
