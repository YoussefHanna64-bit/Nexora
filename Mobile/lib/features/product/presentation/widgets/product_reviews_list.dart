import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/utils/mock_data.dart';
import 'package:nexora/core/widgets/custom_empty_state.dart';
import 'package:nexora/features/product/presentation/widgets/review_card.dart';
import 'package:nexora/features/reviews/domain/entities/review.dart';
import 'package:nexora/features/reviews/presentation/manager/review_cubit.dart';
import 'package:nexora/features/reviews/presentation/manager/review_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductReviewsList extends StatelessWidget {
  final String? currentUserId;

  const ProductReviewsList({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        if (state is ReviewError) {
          return Center(
            child: Text(state.message,
                style: const TextStyle(color: AppColors.redColor)),
          );
        }
        final bool isLoading = state is ReviewLoading;

        final List<Review> reviews = isLoading
            ? MockData.reviews
            : (state is ReviewLoaded ? state.reviews : []);

        if (!isLoading && reviews.isEmpty) {
          return CustomEmptyState(
            icon: AppIcons.starBorder,
            title: AppLocalizations.of(context)!.noReviewsYet,
            subtitle: AppLocalizations.of(context)!.noReviewsYetSubtitle,
          );
        }

        return Skeletonizer(
          enabled: isLoading,
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return ReviewCard(
                review: reviews[index],
                currentUserId: currentUserId,
              );
            },
          ),
        );
      },
    );
  }
}
