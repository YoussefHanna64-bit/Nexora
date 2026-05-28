import 'package:flutter/material.dart';

class CustomCircleIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;

  const CustomCircleIcon(
      {super.key, required this.icon, this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Theme.of(context).colorScheme.onSurface;

    final backgroundColor = color != null
        ? color!.withAlpha(25)
        : Theme.of(context).colorScheme.surface;

    final borderColor =
        color != null ? color!.withAlpha(76) : Theme.of(context).dividerColor;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
      ),
      child: Icon(icon, color: themeColor, size: size),
    );
  }
}
