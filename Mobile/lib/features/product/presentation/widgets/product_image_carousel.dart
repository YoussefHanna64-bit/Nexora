import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/dot_indicator.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;
  const ProductImageCarousel({super.key, required this.images});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          itemCount: widget.images.length,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: widget.images[index],
              fit: BoxFit.contain,
              width: double.infinity,
              errorWidget: (context, url, error) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(AppIcons.brokenImage,
                      size: 48, color: AppColors.greyColor),
                  const SizedBox(height: 8),
                  Text(l10n.imageUnavailable,
                      style: AppTextStyles.regular12Grey),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: 30,
          child: DotIndicator(
            count: widget.images.length,
            currentIndex: currentIndex,
            inactiveColor: AppColors.whiteColor.withAlpha(128),
          ),
        ),
      ],
    );
  }
}
