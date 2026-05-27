import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/profile_image.dart';
import 'package:nexora/features/profile/presentation/widgets/profile_menu_tile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
        appBar: CustomAppBar(title: l10n.profile),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: [
                  ProfileImage(
                    icon: AppIcons.editOutlined,
                    imageUrl:
                        'https://avatarfiles.alphacoders.com/823/thumb-1920-82313.jpg',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  Text('Legend',
                      style: AppTextStyles.extraBold24Black
                          .copyWith(color: onSurface)),
                  const SizedBox(height: 4),
                  Text('Legend@gmail.com', style: AppTextStyles.regular14Grey),
                ],
              ),
              const SizedBox(height: 32),
              ProfileMenuTile(
                icon: AppIcons.editOutlined,
                title: l10n.editProfile,
                onTap: () {},
              ),
              ProfileMenuTile(
                icon: AppIcons.shoppingBagOutlined,
                title: l10n.myOrders,
                onTap: () {},
              ),
              ProfileMenuTile(
                icon: AppIcons.locationOnOutlined,
                title: l10n.shippingAddresses,
                onTap: () {},
              ),
              ProfileMenuTile(
                icon: AppIcons.paymentOutlined,
                title: l10n.paymentMethods,
                onTap: () {},
              ),
              ProfileMenuTile(
                icon: AppIcons.settingsOutlined,
                title: l10n.settings,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              const Divider(indent: 50, endIndent: 50),
              const SizedBox(height: 16),
              ProfileMenuTile(
                icon: AppIcons.logout,
                title: l10n.logOut,
                color: AppColors.redColor,
                showTrailing: false,
                onTap: () {
                  context.go(Routes.login);
                },
              ),
            ],
          ),
        ));
  }
}
