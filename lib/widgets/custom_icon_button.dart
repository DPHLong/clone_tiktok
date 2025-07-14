import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.backgroundColor,
    required this.iconColor,
    required this.borderColor,
    required this.icon,
    this.iconSize,
    this.buttonSize,
    this.onPressed,
  });

  final Color backgroundColor;
  final Color iconColor;
  final Color borderColor;
  final IconData icon;
  final double? iconSize;
  final double? buttonSize;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        height: buttonSize ?? 30,
        width: buttonSize ?? 30,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: iconSize ?? 25),
      ),
      onPressed: () => onPressed?.call(),
    );
  }
}
