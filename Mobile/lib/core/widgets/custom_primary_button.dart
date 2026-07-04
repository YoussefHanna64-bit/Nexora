import 'package:flutter/material.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String buttonText;
  final Color? fillColor;
  final Color? outlineColor;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const CustomPrimaryButton({
    super.key,
    required this.buttonText,
    this.fillColor,
    this.outlineColor,
    this.width = double.infinity,
    this.height,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final loadingWidget = CircularProgressIndicator(
      color:
          isOutlined ? outlineColor ?? AppColors.primary : AppColors.whiteColor,
      strokeWidth: 2,
    );

    final textWidget = Text(
      buttonText,
      style: isOutlined
          ? AppTextStyles.bold16White
              .copyWith(color: outlineColor ?? AppColors.primary)
          : AppTextStyles.bold16White,
    );

    Widget buttonContent() {
      if (isLoading) {
        return loadingWidget;
      }

      if (icon != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isOutlined
                  ? outlineColor ?? AppColors.primary
                  : AppColors.whiteColor,
            ),
            const SizedBox(width: 8),
            textWidget,
          ],
        );
      }
      return textWidget;
    }

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: outlineColor ?? AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onPressed: isLoading ? null : onPressed,
              child: buttonContent(),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isLoading
                    ? AppColors.greyColor
                    : (fillColor ?? AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onPressed: isLoading ? null : onPressed,
              child: buttonContent(),
            ),
    );
  }
}
