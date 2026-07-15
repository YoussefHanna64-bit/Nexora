import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/features/profile/presentation/widgets/profile_header.dart';
import 'package:nexora/core/widgets/custom_list_tile.dart';
import 'package:nexora/features/address/presentation/manager/address_cubit.dart';
import 'package:nexora/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/profile/presentation/manager/profile_cubit.dart';
import 'package:nexora/features/profile/presentation/manager/profile_state.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    final profileCubit = context.read<ProfileCubit>();
    if (profileCubit.state is! ProfileLoaded) {
      profileCubit.fetchProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: CustomAppBar(title: l10n.profile),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                if (state is ProfileError) {
                  return ProfileHeader(
                    icon: AppIcons.wifiOff,
                    title: l10n.connectionFailed,
                    subtitle: l10n.couldntLoadData,
                    subtitleColor: AppColors.redColor,
                    onTap: () {},
                    extraWidget: TextButton.icon(
                      onPressed: () =>
                          context.read<ProfileCubit>().fetchProfile(),
                      icon: const Icon(AppIcons.refresh,
                          color: AppColors.primary),
                      label: Text(l10n.tapToRetry,
                          style: TextStyle(color: AppColors.primary)),
                    ),
                  );
                }

                final isLoading =
                    state is ProfileLoading || state is ProfileInitial;
                final user = state is ProfileLoaded ? state.user : null;

                return Skeletonizer(
                  enabled: isLoading,
                  child: ProfileHeader(
                    icon: AppIcons.editOutlined,
                    title: user?.fullname.split(" ").first ?? l10n.loading,
                    subtitle: user?.email ?? l10n.loading,
                    imageUrl: user?.profileImage,
                    onTap: () {
                      if (!isLoading) context.push(Routes.editProfile);
                    },
                  ),
                );
              }),
              const SizedBox(height: 32),
              CustomListTile(
                icon: AppIcons.editOutlined,
                title: l10n.editProfile,
                onTap: () {
                  context.push(Routes.editProfile);
                },
              ),
              CustomListTile(
                icon: AppIcons.shoppingBagOutlined,
                title: l10n.myOrders,
                onTap: () {
                  context.push(Routes.myOrders);
                },
              ),
              CustomListTile(
                icon: AppIcons.locationOnOutlined,
                title: l10n.shippingAddresses,
                onTap: () {
                  context.push(Routes.shippingAddresses);
                },
              ),
              CustomListTile(
                icon: AppIcons.settingsOutlined,
                title: l10n.settings,
                onTap: () {
                  context.push(Routes.settings);
                },
              ),
              const SizedBox(height: 16),
              const Divider(indent: 50, endIndent: 50),
              const SizedBox(height: 16),
              CustomListTile(
                icon: AppIcons.logout,
                title: l10n.logOut,
                color: AppColors.redColor,
                showTrailing: false,
                onTap: () async {
                  context.read<WishlistCubit>().clearWishlist();
                  context.read<CartCubit>().clearCart();
                  context.read<AddressCubit>().clearAddresses();
                  context.read<ProfileCubit>().clearProfile();

                  await context.read<AuthCubit>().logout();

                  if (context.mounted) {
                    context.go(Routes.login);
                  }
                },
              ),
            ],
          ),
        ));
  }
}
