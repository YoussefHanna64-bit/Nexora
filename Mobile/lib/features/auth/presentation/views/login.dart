import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/utils/app_snackbars.dart';
import 'package:nexora/core/utils/validators.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:nexora/features/auth/presentation/manager/auth/auth_state.dart';
import 'package:nexora/features/auth/presentation/widgets/google_sign_in_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
        if (state is AuthError) {
          String message;

          if (state.message == "google_auth_failed") {
            message = l10n.googleAuthFailed;
          } else {
            message = state.message;
          }

          AppSnackbars.showError(context, message);
        } else if (state is AuthSuccess) {
          AppSnackbars.showSuccess(
            context,
            "${l10n.welcomeBack}, ${state.user.fullname.split(" ").first}!",
          );
          context.go(Routes.home);
        }
      }, builder: (context, state) {
        return Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.welcomeBack,
                        style: AppTextStyles.extraBold28Black
                            .copyWith(color: onSurface),
                      ),
                      Text(
                        l10n.signInSubtitle,
                        style: AppTextStyles.regular14Grey,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        hintText: l10n.email,
                        controller: emailController,
                        validator: (value) => Validators.email(context, value),
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                          hintText: l10n.password,
                          controller: passwordController,
                          validator: (value) =>
                              Validators.password(context, value),
                          obscureText: true),
                      const SizedBox(height: 32),
                      CustomPrimaryButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthCubit>().login(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          buttonText: l10n.login,
                          isLoading: state is AuthLoading),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                            text: l10n.forgotPassword,
                            style: AppTextStyles.bold16Primary,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push(Routes.forgotPassword);
                              }),
                      ),
                      const SizedBox(height: 28),
                      Row(children: [
                        Expanded(
                            child: Divider(
                          color: Theme.of(context).dividerColor,
                          thickness: 2,
                          indent: 10,
                          endIndent: 9,
                        )),
                        Text(
                          l10n.or,
                          style: AppTextStyles.regular14Grey,
                        ),
                        Expanded(
                            child: Divider(
                          color: Theme.of(context).dividerColor,
                          thickness: 2,
                          indent: 10,
                          endIndent: 14,
                        )),
                      ]),
                      const SizedBox(height: 32),
                      GoogleSignInButton(),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.dontHaveAccount,
                            style: AppTextStyles.regular14Grey,
                          ),
                          RichText(
                            text: TextSpan(
                              text: l10n.signUp,
                              style: AppTextStyles.bold16Primary,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.go(Routes.register);
                                },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        );
      }),
    );
  }
}
