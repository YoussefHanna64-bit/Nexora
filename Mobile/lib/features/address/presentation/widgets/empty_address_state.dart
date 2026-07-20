import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/widgets/custom_empty_state.dart';

class EmptyAddressState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const EmptyAddressState({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomEmptyState(
      icon: AppIcons.locationOffOutlined,
      title: l10n.noAddressesYet,
      subtitle: l10n.noAddressesSubtitle,
      buttonText: l10n.addAddress,
      buttonIcon: AppIcons.add,
      onButtonPressed: onAddPressed,
    );
  }
}
