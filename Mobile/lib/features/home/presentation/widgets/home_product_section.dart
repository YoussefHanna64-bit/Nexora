import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/features/product/presentation/widgets/product_grid.dart';
import 'package:nexora/features/product/domain/entities/product.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeProductSection extends StatelessWidget {
  final String title;
  final String sortFilter;
  final bool isLoading;
  final List<Product> products;

  const HomeProductSection({
    super.key,
    required this.title,
    required this.sortFilter,
    required this.isLoading,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.regular18Black.copyWith(color: onSurface),
            ),
            RichText(
              text: TextSpan(
                  text: l10n.viewAll,
                  style: AppTextStyles.bold16Primary,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.push(
                        Routes.search,
                        extra: {
                          "filters": {"sort": sortFilter}
                        },
                      );
                    }),
            )
          ],
        ),
        const SizedBox(height: 16),
        Skeletonizer(
          enabled: isLoading,
          child: ProductGrid(products: products),
        ),
      ],
    );
  }
}
