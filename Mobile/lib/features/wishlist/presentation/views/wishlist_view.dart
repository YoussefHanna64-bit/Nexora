import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/utils/mock_data.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_empty_state.dart';
import 'package:nexora/core/widgets/custom_error_widget.dart';
import 'package:nexora/features/product/presentation/widgets/product_grid.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.wishlist),
      body:
          BlocBuilder<WishlistCubit, WishlistState>(builder: (context, state) {
        if (state is WishlistError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<WishlistCubit>().fetchWishlist();
            },
          );
        }
        final bool isLoading =
            state is WishlistLoading || state is WishlistInitial;

        final wishList =
            isLoading ? MockData.products : (state as WishlistSuccess).wishlist;

        if (wishList.isEmpty) {
          return CustomEmptyState(
            icon: AppIcons.favoritesBorder,
            title: l10n.wishlistEmpty,
            subtitle: l10n.wishlistEmptySubtitle,
            buttonText: l10n.startShopping,
            onButtonPressed: () => context.go(Routes.home),
          );
        }

        return Skeletonizer(
          enabled: isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProductGrid(products: wishList),
              ],
            ),
          ),
        );
      }),
    );
  }
}
