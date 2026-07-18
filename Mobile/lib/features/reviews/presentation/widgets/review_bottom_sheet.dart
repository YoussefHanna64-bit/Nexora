import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/features/reviews/domain/usecases/params/review_params.dart';
import 'package:nexora/features/reviews/presentation/manager/review_cubit.dart';
import 'package:nexora/features/reviews/presentation/manager/review_state.dart';

class ReviewBottomSheet extends StatefulWidget {
  final String productId;

  const ReviewBottomSheet({super.key, required this.productId});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.rateThisProduct,
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
          TextField(
            controller: _commentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: l10n.reviewHint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 24),
          BlocConsumer<ReviewCubit, ReviewState>(
            listener: (context, state) {
              if (state is ReviewActionSuccess) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(l10n.thankYouForYourReview),
                      backgroundColor: AppColors.primary),
                );
              } else if (state is ReviewError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.redColor),
                );
              }
            },
            builder: (context, state) {
              return CustomPrimaryButton(
                buttonText: l10n.submitReview,
                isLoading: state is ReviewLoading,
                onPressed: _rating == 0
                    ? () {}
                    : () {
                        context.read<ReviewCubit>().submitReview(
                              ReviewParams(
                                productId: widget.productId,
                                rating: _rating,
                                comment: _commentController.text,
                              ),
                            );
                      },
              );
            },
          ),
        ],
      ),
    ));
  }
}
