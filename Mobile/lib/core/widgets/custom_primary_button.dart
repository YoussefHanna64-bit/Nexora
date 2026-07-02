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
              ),
              onPressed: isLoading ? null : onPressed,
              child: isLoading ? loadingWidget : textWidget,
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isLoading
                    ? AppColors.greyColor
                    : (fillColor ?? AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: isLoading ? null : onPressed,
              child: isLoading ? loadingWidget : textWidget,
            ),
    );
  }
}
