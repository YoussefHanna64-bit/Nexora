import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/theme/theme_cubit.dart';
import 'package:nexora/core/utils/validators.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';

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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.read<ThemeCubit>().isDark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.04, vertical: h * 0.02),
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
                    SizedBox(
                      height: h * 0.02,
                    ),
                    CustomTextFormField(
                      hintText: l10n.email,
                      controller: emailController,
                      validator: (value) => Validators.email(context, value),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    CustomTextFormField(
                        hintText: l10n.password,
                        controller: passwordController,
                        validator: (value) =>
                            Validators.password(context, value),
                        obscureText: true),
                    SizedBox(
                      height: h * 0.04,
                    ),
                    CustomPrimaryButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.go(Routes.home);
                          }
                        },
                        buttonText: l10n.login,
                        isLoading: false),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    RichText(
                      text: TextSpan(
                          text: l10n.forgotPassword,
                          style: AppTextStyles.bold16Primary,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go(Routes.register);
                            }),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
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
                    SizedBox(
                      height: h * 0.04,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        AppIcons.google,
                        height: 20,
                        width: 20,
                      ),
                      label: Text(
                        l10n.signInWithGoogle,
                        style: AppTextStyles.regular14Black
                            .copyWith(color: onSurface),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 0),
                        shadowColor: Colors.transparent,
                        backgroundColor:
                            Theme.of(context).colorScheme.surface,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        side: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.04,
                    ),
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
      ),
    );
  }
}
