import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/localization/language_cubit.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/utils/app_dialogs.dart';
import 'package:nexora/features/reviews/domain/entities/review.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/features/reviews/presentation/manager/review_cubit.dart';
import 'package:nexora/features/reviews/presentation/widgets/review_bottom_sheet.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final String? currentUserId;

  const ReviewCard({
    super.key,
    required this.review,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final bool isMyReview =
        currentUserId != null && review.userId == currentUserId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withAlpha(25),
              ),
              child: ClipOval(
                child: (review.userProfileImage == null ||
                        review.userProfileImage!.isEmpty)
                    ? const Center(
                        child: Icon(
                          AppIcons.profile,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: review.userProfileImage!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          AppIcons.profile,
                          size: 20,
                          color: AppColors.primary.withAlpha(100),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName,
                    style: AppTextStyles.bold14Black.copyWith(color: onSurface),
                  ),
                  Text(
                    DateFormat("dd MMM yyyy",
                            context.read<LanguageCubit>().state.languageCode)
                        .format(review.createdAt),
                    style: AppTextStyles.regular12Grey,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      starIndex < review.rating
                          ? AppIcons.star
                          : AppIcons.starBorder,
                      color: AppColors.goldColor,
                      size: 16,
                    );
                  }),
                ),
                if (isMyReview)
                  PopupMenuButton<String>(
                    borderRadius: BorderRadius.circular(12),
                    icon: const Icon(AppIcons.moreVert,
                        color: AppColors.greyColor),
                    onSelected: (value) {
                      if (value == "edit") {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          builder: (sheetContext) => BlocProvider.value(
                            value: context.read<ReviewCubit>(),
                            child: ReviewBottomSheet(
                              productId: review.productId,
                              existingReview: review,
                            ),
                          ),
                        );
                      } else if (value == "remove") {
                        AppDialogs.showConfirmDialog(
                          context,
                          title: l10n.deleteReviewTitle,
                          content: l10n.deleteReviewContent,
                          confirmText: l10n.delete,
                          cancelText: l10n.cancel,
                          onConfirm: () {
                            context.read<ReviewCubit>().removeReview(review.id);
                          },
                          isDanger: true,
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "edit",
                        child: Row(children: [
                          Icon(AppIcons.edit, size: 20),
                          SizedBox(width: 8),
                          Text(l10n.edit)
                        ]),
                      ),
                      PopupMenuItem(
                        value: "remove",
                        child: Row(children: [
                          Icon(AppIcons.delete,
                              color: AppColors.redColor, size: 20),
                          SizedBox(width: 8),
                          Text(l10n.remove,
                              style: TextStyle(color: AppColors.redColor))
                        ]),
                      ),
                    ],
                  ),
              ],
            )
          ],
        ),
        if (review.comment != null && review.comment!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            review.comment!,
            style: AppTextStyles.regular14Grey.copyWith(color: onSurface),
          ),
        ]
      ],
    );
  }
}
