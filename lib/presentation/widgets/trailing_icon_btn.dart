import 'package:flutter/material.dart';
import 'package:project_emp/core/constants/constants.dart'; 

class TrailingButton extends StatelessWidget {
  final String label;
  final Icon? icon;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? labelColor;
  const TrailingButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.borderColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: icon,
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(40, 30),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(btnRadius),
        ),
        side: BorderSide(
          color: borderColor ?? Theme.of(context).colorScheme.primary,
          width: 0.5,
        ),
      ),
      label: Text(
        label,
        style: TextStyle(fontSize: btnFontSize, color: labelColor),
      ),
    );
  }
}
