import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/utils/app_snackbars.dart';
import 'package:nexora/core/utils/validators.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/features/auth/presentation/manager/forgot_password/forgot_password_cubit.dart';
import 'package:nexora/features/auth/presentation/manager/forgot_password/forgot_password_state.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late PageController _pageController;

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _newPasswordFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.resetPassword,
        showBackButton: true,
        onBackPressed: () {
          if (_pageController.page == 0) {
            context.pop();
          } else {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordError) {
            AppSnackbars.showError(context, state.message);
          } else if (state is ForgotPasswordEmailSent) {
            _nextPage();
          } else if (state is ForgotPasswordOTPVerified) {
            _nextPage();
          } else if (state is ForgotPasswordSuccess) {
            AppSnackbars.showSuccess(context, l10n.passwordResetSuccess);
            context.go(Routes.home);
          }
        },
        builder: (context, state) {
          final isLoading = state is ForgotPasswordLoading;

          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _emailStep(isLoading, l10n, onSurface),
              _otpStep(isLoading, l10n, onSurface),
              _newPasswordStep(isLoading, l10n, onSurface),
            ],
          );
        },
      ),
    );
  }

  Widget _emailStep(bool isLoading, AppLocalizations l10n, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Form(
        key: _emailFormKey,
        child: Column(
          children: [
            Text(
              l10n.enterRegisteredEmailInfo,
              style: AppTextStyles.regular14Grey.copyWith(color: onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              hintText: l10n.email,
              controller: _emailController,
              showLabel: true,
              validator: (value) => Validators.email(context, value),
            ),
            const Spacer(),
            CustomPrimaryButton(
              buttonText: l10n.send,
              isLoading: isLoading,
              onPressed: () {
                if (_emailFormKey.currentState!.validate()) {
                  context
                      .read<ForgotPasswordCubit>()
                      .forgotPassword(_emailController.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpStep(bool isLoading, AppLocalizations l10n, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Form(
        key: _otpFormKey,
        child: Column(
          children: [
            Text(
              l10n.enterOtpInfo,
              style: AppTextStyles.regular14Grey.copyWith(color: onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              hintText: l10n.enterOtp,
              controller: _otpController,
              showLabel: true,
              validator: (value) => Validators.otp(context, value),
            ),
            const Spacer(),
            CustomPrimaryButton(
              buttonText: l10n.verify,
              isLoading: isLoading,
              onPressed: () {
                if (_otpFormKey.currentState!.validate()) {
                  context
                      .read<ForgotPasswordCubit>()
                      .verifyOTP(_otpController.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _newPasswordStep(
      bool isLoading, AppLocalizations l10n, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Form(
        key: _newPasswordFormKey,
        child: Column(
          children: [
            Text(
              l10n.createNewPasswordInfo,
              style: AppTextStyles.regular14Grey.copyWith(color: onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              hintText: l10n.newPassword,
              controller: _newPasswordController,
              validator: (value) => Validators.password(context, value,
                  customErrorMessage: l10n.newPasswordRequired),
              obscureText: true,
              showLabel: true,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              hintText: l10n.confirmPassword,
              controller: _confirmPasswordController,
              validator: (value) => Validators.confirmPassword(
                  context, value, _newPasswordController.text),
              obscureText: true,
              showLabel: true,
            ),
            const Spacer(),
            CustomPrimaryButton(
              buttonText: l10n.resetPassword,
              isLoading: isLoading,
              onPressed: () {
                if (_newPasswordFormKey.currentState!.validate()) {
                  context.read<ForgotPasswordCubit>().resetPassword(
                        newPassword: _newPasswordController.text,
                        confirmPassword: _confirmPasswordController.text,
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
