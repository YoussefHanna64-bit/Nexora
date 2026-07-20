import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/utils/app_snackbars.dart';
import 'package:nexora/core/utils/validators.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/features/profile/presentation/manager/profile_cubit.dart';
import 'package:nexora/features/profile/presentation/manager/profile_state.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  void _onSave() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().changePassword(
            _currentPasswordController.text,
            _newPasswordController.text,
            _confirmPasswordController.text,
          );
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
        appBar: CustomAppBar(
          title: l10n.changePassword,
          showBackButton: true,
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) async {
          if (state is PasswordChangeSuccess) {
            AppSnackbars.showSuccess(context, l10n.passwordChanged);
            context.pop();
          }
        }, builder: (context, state) {
          final isLoading = state is ProfileUpdating;
          return Form(
              key: _formKey,
              child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(children: [
                    Text(
                      l10n.passwordPolicy,
                      style: AppTextStyles.regular14Grey
                          .copyWith(color: onSurface),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    CustomTextFormField(
                      hintText: l10n.currentPassword,
                      controller: _currentPasswordController,
                      validator: (value) => Validators.password(context, value,
                          customErrorMessage: l10n.currentPasswordRequired),
                      obscureText: true,
                      showLabel: true,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      hintText: l10n.newPassword,
                      controller: _newPasswordController,
                      validator: (value) => Validators.password(context, value,
                          customErrorMessage: l10n.newPasswordRequired),
                      obscureText: true,
                      showLabel: true,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      hintText: l10n.confirmNewPassword,
                      controller: _confirmPasswordController,
                      validator: (value) => Validators.confirmPassword(
                          context, value, _newPasswordController.text),
                      obscureText: true,
                      showLabel: true,
                    ),
                    const SizedBox(height: 48),
                    CustomPrimaryButton(
                      buttonText: l10n.updatePassword,
                      onPressed: isLoading ? () {} : _onSave,
                      isLoading: isLoading,
                    ),
                  ])));
        }));
  }
}
