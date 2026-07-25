import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/di/dependency_injection.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/utils/mock_data.dart';
import 'package:nexora/core/widgets/custom_error_widget.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/features/banner/presentation/manager/banner_cubit.dart';
import 'package:nexora/features/banner/presentation/manager/banner_state.dart';
import 'package:nexora/features/brands/presentation/manager/brand_cubit.dart';
import 'package:nexora/features/brands/presentation/manager/brand_state.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/cart/presentation/manager/cart_state.dart';
import 'package:nexora/features/category/presentation/manager/category_cubit.dart';
import 'package:nexora/features/category/presentation/manager/category_state.dart';
import 'package:nexora/features/home/presentation/widgets/brand_list.dart';
import 'package:nexora/features/home/presentation/widgets/category_list.dart';
import 'package:nexora/features/home/presentation/widgets/home_banners.dart';
import 'package:nexora/features/home/presentation/widgets/home_product_section.dart';
import 'package:nexora/features/product/domain/entities/product.dart';
import 'package:nexora/features/product/presentation/manager/product/product_cubit.dart';
import 'package:nexora/features/product/presentation/manager/product/product_state.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final ProductCubit popularCubit;
  late final ProductCubit saleCubit;

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

    popularCubit = getIt<ProductCubit>()
      ..fetchProducts(queryParameters: {
        "sort": "-sold",
        "limit": 6,
      });

    saleCubit = getIt<ProductCubit>()
      ..fetchProducts(queryParameters: {
        "sort": "-discount",
        "limit": 6,
      });
  }

  @override
  void dispose() {
    popularCubit.close();
    saleCubit.close();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;
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
          return BlocBuilder<BrandCubit, BrandState>(
              builder: (context, brandState) {
            return BlocBuilder<ProductCubit, ProductState>(
                bloc: popularCubit,
                builder: (context, popularState) {
                  return BlocBuilder<ProductCubit, ProductState>(
                      bloc: saleCubit,
                      builder: (context, saleState) {
                        if (bannerState is BannerError ||
                            categoryState is CategoryError ||
                            brandState is BrandError ||
                            popularState is ProductError ||
                            saleState is ProductError) {
                          String errorMessage = l10n.couldntLoadData;
                          if (bannerState is BannerError) {
                            errorMessage = bannerState.message;
                          } else if (categoryState is CategoryError) {
                            errorMessage = categoryState.message;
                          } else if (brandState is BrandError) {
                            errorMessage = brandState.message;
                          } else if (popularState is ProductError) {
                            errorMessage = popularState.message;
                          } else if (saleState is ProductError) {
                            errorMessage = saleState.message;
                          }

                          return CustomErrorWidget(
                            message: errorMessage,
                            onRetry: () {
                              context.read<BannerCubit>().fetchBanners();
                              context.read<CategoryCubit>().fetchCategories();
                              context.read<BrandCubit>().fetchBrands();
                              popularCubit.fetchProducts(queryParameters: {
                                "sort": "-sold",
                                "limit": 6,
                              });
                              saleCubit.fetchProducts(queryParameters: {
                                "sort": "-discount",
                                "limit": 6,
                              });
                            },
                          );
                        }

                        final bool isPopularLoading =
                            popularState is ProductLoading ||
                                popularState is ProductInitial;
                        final bool isSaleLoading =
                            saleState is ProductLoading ||
                                saleState is ProductInitial;

                        final displayPopularProducts = isPopularLoading
                            ? MockData.products
                            : (popularState as ProductSuccess).products;

                        final displaySaleProducts = isSaleLoading
                            ? MockData.products
                            : (saleState as ProductSuccess).products;

                        return SingleChildScrollView(
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: h * 0.22,
                                          child: HomeBanners()),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.shopByCategory,
                                        style: AppTextStyles.regular18Black
                                            .copyWith(color: onSurface),
                                      ),
                                      const SizedBox(height: 16),
                                      CategoryList(),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.shopByBrand,
                                        style: AppTextStyles.regular18Black
                                            .copyWith(color: onSurface),
                                      ),
                                      const SizedBox(height: 16),
                                      BrandList(),
                                      const SizedBox(height: 16),
                                      HomeProductSection(
                                        title: l10n.popularProducts,
                                        sortFilter: "-sold",
                                        isLoading: isPopularLoading,
                                        products: List<Product>.from(
                                            displayPopularProducts),
                                      ),
                                      const SizedBox(height: 16),
                                      HomeProductSection(
                                        title: l10n.productsOnSale,
                                        sortFilter: "-discount",
                                        isLoading: isSaleLoading,
                                        products: List<Product>.from(
                                            displaySaleProducts),
                                      ),
                                    ])));
                      });
                });
          });
        });
      }),
    );
  }
}
