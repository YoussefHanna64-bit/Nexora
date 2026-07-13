import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/utils/app_dialogs.dart';
import 'package:nexora/core/utils/validators.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/features/profile/presentation/widgets/image_picker_bottom_sheet.dart';
import 'package:nexora/features/profile/presentation/widgets/profile_image.dart';
import 'package:nexora/features/address/presentation/manager/address_cubit.dart';
import 'package:nexora/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/profile/presentation/manager/profile_cubit.dart';
import 'package:nexora/features/profile/presentation/manager/profile_state.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      _nameController.text = profileState.user.fullname;
      _emailController.text = profileState.user.email;
    }
  }

  void _onSave() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateProfile(
            fullname: _nameController.text.trim(),
            email: _emailController.text.trim(),
          );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: CustomAppBar(
          title: l10n.editProfile,
          showBackButton: true,
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) async {
          _editProfileBlocListener(context, state, l10n);
        }, builder: (context, state) {
          final isLoading = state is ProfileLoading || state is ProfileInitial;
          final isUpdating = state is ProfileUpdating;
          final user = state is ProfileLoaded ? state.user : null;

          return Skeletonizer(
            enabled: isLoading,
            child: Form(
                key: _formKey,
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Column(children: [
                            ProfileImage(
                              icon: AppIcons.camera,
                              imageUrl: user?.profileImage ?? "",
                              radius: 54,
                              onTap: () {
                                showModalBottomSheet(
                                    showDragHandle: true,
                                    context: context,
                                    builder: (context) =>
                                        const ImagePickerBottomSheet());
                              },
                            ),
                            const SizedBox(height: 32),
                            CustomTextFormField(
                              hintText: l10n.fullName,
                              showLabel: true,
                              controller: _nameController,
                              validator: (val) =>
                                  Validators.username(context, val),
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              hintText: l10n.email,
                              showLabel: true,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) =>
                                  Validators.email(context, val),
                            ),
                            const SizedBox(height: 32),
                            CustomPrimaryButton(
                              buttonText: l10n.saveChanges,
                              onPressed: isUpdating ? () {} : _onSave,
                              isLoading: isUpdating,
                            ),
                            const SizedBox(height: 24),
                            const Divider(thickness: 1, height: 1),
                            const SizedBox(height: 24),
                            CustomPrimaryButton(
                              buttonText: l10n.changePassword,
                              isOutlined: true,
                              onPressed: () {
                                context.push(Routes.changePassword);
                              },
                              icon: AppIcons.lockOutlined,
                            ),
                            const Spacer(),
                            const SizedBox(height: 32),
                            TextButton(
                              onPressed: () {
                                AppDialogs.showConfirmDialog(
                                  context,
                                  title: l10n.deleteAccount,
                                  content: l10n.deleteAccountConfirmation,
                                  confirmText: l10n.delete,
                                  cancelText: l10n.cancel,
                                  onConfirm: () {
                                    context
                                        .read<ProfileCubit>()
                                        .deleteAccount();
                                  },
                                  isDanger: true,
                                );
                              },
                              child: Text(
                                l10n.deleteAccount,
                                style: AppTextStyles.bold16Red,
                              ),
                            ),
                          ])),
                    ),
                  ],
                )),
          );
        }));
  }

  Future<void> _editProfileBlocListener(
      BuildContext context, ProfileState state, AppLocalizations l10n) async {
    if (state is ProfileError) {
      String message;

      if (state.message == "profile_image_upload_error") {
        message = l10n.imagePickingError;
      } else {
        message = state.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.redColor),
      );
    } else if (state is ProfileLoaded) {
      _nameController.text = state.user.fullname;
      _emailController.text = state.user.email;
    } else if (state is ProfileUpdateSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.profileUpdated),
            backgroundColor: AppColors.primary),
      );
    } else if (state is AccountDeletedSuccess) {
      context.read<WishlistCubit>().clearWishlist();
      context.read<CartCubit>().clearCart();
      context.read<AddressCubit>().clearAddresses();
      context.read<ProfileCubit>().clearProfile();

      await context.read<AuthCubit>().logout();

      if (context.mounted) {
        context.go(Routes.login);
      }
    }
  }
}
