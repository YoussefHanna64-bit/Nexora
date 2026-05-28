import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/models/category_model.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/core/widgets/product_grid.dart';
import 'package:nexora/features/home/presentation/widgets/category_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04, vertical: h * 0.02),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: h * 0.22,
                        child: CarouselView(itemExtent: w * 0.8, children: [
                          Image.network('https://picsum.photos/id/20/800/400',
                              fit: BoxFit.cover),
                          Image.network('https://i.imgur.com/Qphac99.jpeg',
                              fit: BoxFit.cover),
                          Image.network('https://picsum.photos/id/60/800/400',
                              fit: BoxFit.cover),
                        ]),
                      ),
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
                      CategoryList(categories: dummyCategories),
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
                      ProductGrid(products: dummyProducts),
                    ]))));
  }
}
