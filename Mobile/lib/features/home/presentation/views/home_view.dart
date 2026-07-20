import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/utils/mock_data.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_error_widget.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/core/widgets/product_grid.dart';
import 'package:nexora/features/banner/presentation/manager/banner_cubit.dart';
import 'package:nexora/features/banner/presentation/manager/banner_state.dart';
import 'package:nexora/features/category/presentation/manager/category_cubit.dart';
import 'package:nexora/features/category/presentation/manager/category_state.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/cart/presentation/manager/cart_state.dart';
import 'package:nexora/features/home/presentation/widgets/category_list.dart';
import 'package:nexora/features/home/presentation/widgets/home_banners.dart';
import 'package:nexora/features/product/presentation/manager/product/product_cubit.dart';
import 'package:nexora/features/product/presentation/manager/product/product_state.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      final cartState = context.read<CartCubit>().state;
      if (cartState is CartInitial || cartState is CartError) {
        context.read<CartCubit>().fetchCart();
      }

      final wishlistState = context.read<WishlistCubit>().state;
      if (wishlistState is WishlistInitial || wishlistState is WishlistError) {
        context.read<WishlistCubit>().fetchWishlist();
      }

      final bannerState = context.read<BannerCubit>().state;
      if (bannerState is BannerInitial || bannerState is BannerError) {
        context.read<BannerCubit>().fetchBanners();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: CustomTextFormField(
            hintText: l10n.search,
            controller: searchController,
            prefixIcon: AppIcons.searchIcon,
            validator: (value) => null,
            onTap: () {
              context.push(Routes.search);
            },
          ),
        ),
        body: BlocBuilder<BannerCubit, BannerState>(
            builder: (context, bannerState) {
          return BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, categoryState) {
            return BlocBuilder<ProductCubit, ProductState>(
                builder: (context, productState) {
              if (bannerState is BannerError ||
                  categoryState is CategoryError ||
                  productState is ProductError) {
                String errorMessage = l10n.couldntLoadData;
                if (bannerState is BannerError) {
                  errorMessage = bannerState.message;
                } else if (categoryState is CategoryError) {
                  errorMessage = categoryState.message;
                } else if (productState is ProductError) {
                  errorMessage = productState.message;
                }

                return CustomErrorWidget(
                  message: errorMessage,
                  onRetry: () {
                    context.read<BannerCubit>().fetchBanners();
                    context.read<CategoryCubit>().fetchCategories();
                    context
                        .read<ProductCubit>()
                        .fetchProducts(queryParameters: {
                      "sort": "-sold",
                      "limit": 6,
                    });
                  },
                );
              }

              final bool isLoading = productState is ProductLoading ||
                  productState is ProductInitial;

              final displayProducts = isLoading
                  ? MockData.products
                  : (productState as ProductSuccess).products;

              return SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: w * 0.04, vertical: h * 0.02),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: h * 0.22, child: HomeBanners()),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Text(
                              l10n.shopByCategory,
                              style: AppTextStyles.regular18Black
                                  .copyWith(color: onSurface),
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            CategoryList(),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.popularProducts,
                                  style: AppTextStyles.regular18Black
                                      .copyWith(color: onSurface),
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: l10n.viewAll,
                                      style: AppTextStyles.bold16Primary,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {}),
                                )
                              ],
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Skeletonizer(
                              enabled: isLoading,
                              child: ProductGrid(products: displayProducts),
                            )
                          ])));
            });
          });
        }));
  }
}
