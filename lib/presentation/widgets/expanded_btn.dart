import 'package:flutter/material.dart';

 

 
class ExpandedBtn extends StatelessWidget {
  final Widget? child;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  const ExpandedBtn({super.key, this.child, this.onPressed, this.style});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(style: style, onPressed: onPressed, child: child),
        ),
      ],
    );
  }
}
