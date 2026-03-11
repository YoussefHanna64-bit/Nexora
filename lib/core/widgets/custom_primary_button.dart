import 'package:flutter/material.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';


class CustomPrimaryButton extends StatelessWidget {
  final String buttonText;
  final Color? fillColor;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool isLoading;

  const CustomPrimaryButton({
    super.key,
    required this.buttonText,
    this.fillColor,
    this.width = double.infinity,
    this.height,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:width??double.infinity,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(isLoading
              ? AppColors.greyColor
              : AppColors.primary),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(
          color: AppColors.whiteColor,
          strokeWidth: 2,
        )
            : Text(buttonText, style: AppTextStyles.bold16White),
      ),
    );
  }
}
