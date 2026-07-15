import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:nexora/features/auth/presentation/manager/auth/auth_state.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return ElevatedButton.icon(
      onPressed: () {
        if (context.read<AuthCubit>().state is! AuthLoading) {
          context.read<AuthCubit>().googleAuth();
        }
      },
      icon: Image.asset(
        AppIcons.google,
        height: 20,
        width: 20,
      ),
      label: Text(
        l10n.continueWithGoogle,
        style: AppTextStyles.regular14Black.copyWith(color: onSurface),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 0),
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
    );
  }
}
