import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/utils/app_snackbars.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/features/reviews/domain/entities/review.dart';
import 'package:nexora/features/reviews/domain/usecases/params/review_params.dart';
import 'package:nexora/features/reviews/presentation/manager/review_cubit.dart';
import 'package:nexora/features/reviews/presentation/manager/review_state.dart';

class ReviewBottomSheet extends StatefulWidget {
  final String productId;
  final Review? existingReview;

  const ReviewBottomSheet(
      {super.key, required this.productId, this.existingReview});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _rating = widget.existingReview!.rating.toDouble();
      _commentController.text = widget.existingReview!.comment ?? "";
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isEditing = widget.existingReview != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? l10n.editYourReview : l10n.rateThisProduct,
            style: AppTextStyles.bold20White.copyWith(color: onSurface),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                iconSize: 40,
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
                icon: Icon(
                  index < _rating ? AppIcons.star : AppIcons.starBorder,
                  color: AppColors.goldColor,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
              controller: _commentController,
              maxLines: 4,
              hintText: l10n.reviewHint,
              validator: null),
          const SizedBox(height: 24),
          BlocConsumer<ReviewCubit, ReviewState>(
            listener: (context, state) {
              if (state is ReviewActionSuccess) {
                Navigator.pop(context);
                String message;

                if (isEditing) {
                  message = l10n.reviewUpdated;
                } else {
                  message = l10n.thankYouForYourReview;
                }

                AppSnackbars.showSuccess(context, message);
              } else if (state is ReviewError) {
                Navigator.pop(context);
                AppSnackbars.showError(context, state.message);
              }
            },
            builder: (context, state) {
              return CustomPrimaryButton(
                buttonText: isEditing ? l10n.updateReview : l10n.submitReview,
                isLoading: state is ReviewLoading,
                onPressed: _rating == 0
                    ? () {}
                    : () {
                        final review = ReviewParams(
                          productId: widget.productId,
                          rating: _rating,
                          comment: _commentController.text,
                        );

                        if (isEditing) {
                          context
                              .read<ReviewCubit>()
                              .editReview(widget.productId, review);
                        } else {
                          context.read<ReviewCubit>().submitReview(review);
                        }
                      },
              );
            },
          ),
        ],
      )),
    );
  }
}
