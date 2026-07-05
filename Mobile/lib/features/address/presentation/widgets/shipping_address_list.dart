import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/utils/app_dialogs.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/address/presentation/manager/address_cubit.dart';
import 'package:nexora/features/address/presentation/widgets/shipping_address_card.dart';

class ShippingAddressList extends StatelessWidget {
  final List<ShippingAddress> addresses;

  const ShippingAddressList({super.key, required this.addresses});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: addresses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final address = addresses[index];
        return ShippingAddressCard(
          address: address,
          trailing: PopupMenuButton<String>(
            borderRadius: BorderRadius.circular(12),
            icon: Icon(AppIcons.moreVert, color: AppColors.greyColor),
            onSelected: (value) {
              if (value == "edit") {
                context.push(Routes.addEditAddress, extra: address);
              } else if (value == "remove") {
                AppDialogs.showConfirmDialog(
                  context,
                  title: l10n.removeAddress,
                  content: l10n.removeAddressConfirmation,
                  confirmText: l10n.remove,
                  cancelText: l10n.cancel,
                  onConfirm: () {
                    context.read<AddressCubit>().removeAddress(address.id!);
                  },
                  isDanger: true,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "edit",
                child: Row(children: [
                  Icon(AppIcons.edit, size: 20),
                  SizedBox(width: 8),
                  Text(l10n.edit)
                ]),
              ),
              PopupMenuItem(
                value: "remove",
                child: Row(children: [
                  Icon(AppIcons.delete, color: AppColors.redColor, size: 20),
                  SizedBox(width: 8),
                  Text(l10n.remove, style: TextStyle(color: AppColors.redColor))
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
