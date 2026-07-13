import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/features/profile/presentation/manager/profile_cubit.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(
        leading: const Icon(AppIcons.photoLibrary, color: AppColors.primary),
        title: Text(l10n.chooseFromGallery),
        onTap: () {
          Navigator.pop(context);
          context.read<ProfileCubit>().pickAndUploadImage(ImageSource.gallery);
        },
      ),
      ListTile(
        leading: const Icon(AppIcons.camera, color: AppColors.primary),
        title: Text(l10n.takeAPhoto),
        onTap: () {
          Navigator.pop(context);
          context.read<ProfileCubit>().pickAndUploadImage(ImageSource.camera);
        },
      ),
    ]));
  }
}
