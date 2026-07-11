import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/features/banner/domain/entities/banner.dart';
import 'package:nexora/features/banner/presentation/manager/banner_cubit.dart';
import 'package:nexora/features/banner/presentation/manager/banner_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeBanners extends StatelessWidget {
  const HomeBanners({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    var w = MediaQuery.of(context).size.width;

    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        if (state is BannerError) {
          return Center(
            child: Text(l10n.failedToLoadBanners,
                style: TextStyle(color: AppColors.redColor)),
          );
        }

        final isLoading = state is BannerInitial || state is BannerLoading;

        final banners =
            state is BannerLoaded ? state.banners : PromoBanner.mockBanners;

        if (banners.isEmpty && !isLoading) {
          return const SizedBox.shrink();
        }

        return Skeletonizer(
          enabled: isLoading,
          child: CarouselSlider.builder(
            itemCount: banners.length,
            options: CarouselOptions(
              height: double.infinity,
              autoPlay: !isLoading,
              autoPlayInterval: const Duration(seconds: 4),
              viewportFraction: 1.0,
              enlargeCenterPage: false,
            ),
            itemBuilder: (context, index, realIndex) {
              final banner = banners[index];

              return GestureDetector(
                onTap: () {
                  if (isLoading) {
                    return;
                  }

                  if (banner.type == "product") {
                    context.push(Routes.productDetails, extra: banner.target);
                  } else if (banner.type == "search") {
                    context.push(Routes.search, extra: banner.target);
                  }
                },
                child: Container(
                  width: w,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).cardColor,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: banner.image,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    errorWidget: (context, url, error) => Container(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(AppIcons.brokenImage,
                              size: 32, color: AppColors.greyColor),
                          SizedBox(height: 4),
                          Text(l10n.imageUnavailable,
                              style: AppTextStyles.regular12Grey),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
