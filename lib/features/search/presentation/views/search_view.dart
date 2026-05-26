import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/core/widgets/product_grid.dart';

class SearchView extends StatefulWidget {
  final String? initialSearchQuery;

  const SearchView({super.key, this.initialSearchQuery});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController =
        TextEditingController(text: widget.initialSearchQuery ?? '');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                  autoFocus: true,
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
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.results,
                  style: AppTextStyles.bold14Black.copyWith(color: onSurface),
                ),
                Text(
                  l10n.countFound(dummyProducts.length),
                  style: AppTextStyles.regular14Grey,
                ),
              ],
            ),
            SizedBox(height: h * 0.02),
            ProductGrid(products: dummyProducts),
          ],
        ),
      ),
    );
  }
}
