import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/core/widgets/product_grid.dart';
import 'package:nexora/features/product/presentation/manager/product_cubit.dart';
import 'package:nexora/features/product/presentation/manager/product_state.dart';
import 'package:nexora/features/search/presentation/widgets/filter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchView extends StatefulWidget {
  final String? initialSearchQuery;

  const SearchView({super.key, this.initialSearchQuery});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController searchController;

  Map<String, dynamic> activeFilters = {};

  Timer? debounce;

  @override
  void initState() {
    super.initState();
    searchController =
        TextEditingController(text: widget.initialSearchQuery ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) => search());
  }

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void search() {
    final Map<String, dynamic> queryParameters = {...activeFilters};

    if (searchController.text.trim().isNotEmpty) {
      queryParameters['keyword'] = searchController.text.trim();
    }

    context
        .read<ProductCubit>()
        .fetchProducts(queryParameters: queryParameters);
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
        leading: IconButton(
          icon: Icon(AppIcons.arrowBack, color: onSurface, size: 20),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  hintText: l10n.search,
                  controller: searchController,
                  validator: (value) => null,
                  autoFocus: widget.initialSearchQuery == null ||
                      widget.initialSearchQuery!.isEmpty,
                  onChanged: (value) {
                    debounce?.cancel();
                    debounce = Timer(const Duration(milliseconds: 500), () {
                      search();
                    });
                  },
                ),
              ),
              SizedBox(width: w * 0.02),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(AppIcons.tune, color: AppColors.whiteColor),
                  onPressed: () async {
                    RangeValues? savedPriceRange;
                    if (activeFilters.containsKey('price[gte]') &&
                        activeFilters.containsKey('price[lte]')) {
                      savedPriceRange = RangeValues(
                        (activeFilters['price[gte]'] as num).toDouble(),
                        (activeFilters['price[lte]'] as num).toDouble(),
                      );
                    }

                    String? savedCategoryId = activeFilters['category'];

                    double maxPrice = 10000;

                    final currentState = context.read<ProductCubit>().state;
                    if (currentState is ProductSuccess) {
                      maxPrice = currentState.maxPrice;
                    }

                    final Map<String, dynamic>? filters =
                        await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Filter(
                          initialPriceRange: savedPriceRange,
                          initialCategoryId: savedCategoryId,
                          maxPrice: maxPrice,
                        );
                      },
                    );

                    if (filters != null) {
                      setState(() {
                        activeFilters = filters;
                      });
                      search();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
        if (state is ProductError) {
          return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.red)));
        }

        final bool isLoading =
            state is ProductLoading || state is ProductInitial;

        final displayProducts =
            (state is ProductSuccess) ? state.products : dummyProducts;

        return SingleChildScrollView(
          padding:
              EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.02),
          child: Skeletonizer(
            enabled: isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.results,
                      style:
                          AppTextStyles.bold14Black.copyWith(color: onSurface),
                    ),
                    Text(
                      l10n.countFound(displayProducts.length),
                      style: AppTextStyles.regular14Grey,
                    ),
                  ],
                ),
                SizedBox(height: h * 0.02),
                ProductGrid(products: displayProducts),
              ],
            ),
          ),
        );
      }),
    );
  }
}
