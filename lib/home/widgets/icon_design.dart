import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/utils/extensions.dart';

class IconDesign extends StatelessWidget {
  IconDesign({
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
  });
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? context.colorScheme.primaryContainer;
    final Color borderClr = borderColor ?? context.colorScheme.primary;
    final Color iconClr = iconColor ?? context.colorScheme.onPrimary;
    return Container(
      height: Sizes.s45h,
      width: Sizes.s45w,
      decoration:
      BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: borderClr,
          width: Sizes.s1w,
        ),
        borderRadius: BorderRadius.circular(Sizes.s15r),
      ),
      child:
      Icon(
        icon,
        color: iconClr,
        size: Sizes.s25w,
      ),
    );
  }
}
