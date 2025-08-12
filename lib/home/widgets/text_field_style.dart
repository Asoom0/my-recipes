import 'package:easy_localization/easy_localization.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/core/strings/strings.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {

  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      // textAlign: TextAlign.left,
      style: context.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      //TextStyle(color: context.colorScheme.onSurface,),
      obscureText: _obscurePassword,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: context.colorScheme.onSurface,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        hintText: 'text_field_style.password'.tr(),
        labelText: 'text_field_style.password'.tr(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.s12r),
          borderSide: BorderSide(
            color: context.colorScheme.onSurface,
            width: Sizes.s2w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.s12r),
          borderSide: BorderSide(
            color: context.colorScheme.primary,
            width: Sizes.s2AndHalf,
          ),
        ),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.controller,
    required this.icon,
  });
  final TextEditingController controller;
  final IconData icon;


  @override
  Widget build(BuildContext context) {
    return  TextField(
      // textAlign: TextAlign.left,
      style: context.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
        ),
        hintText: 'text_field_style.email'.tr(),
        labelText: 'text_field_style.email'.tr(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.s12r),
          borderSide: BorderSide(
            color: context.colorScheme.onSurface,
            width: Sizes.s2w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.s12r),
          borderSide: BorderSide(
            color: context.colorScheme.primary,
            width: Sizes.s2AndHalf,
          ),
        ),
      ),
    );
  }
}


class NameTextField extends StatelessWidget {
  const NameTextField({
    super.key,
    required this.controller,
    required this.icon,
  });
  final TextEditingController controller;
  final IconData icon;


  @override
  Widget build(BuildContext context) {
    return  TextField(
      // textAlign: TextAlign.left,
      style: context.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
        ),
        hintText: 'text_field_style.name'.tr(),
        labelText: 'text_field_style.name'.tr(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.s12r),
          borderSide: BorderSide(
            color: context.colorScheme.onSurface,
            width: Sizes.s2w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.s12r),
          borderSide: BorderSide(
            color: context.colorScheme.primary,
            width: Sizes.s2AndHalf,
          ),
        ),
      ),
    );
  }
}


class TextFieldStyle extends StatelessWidget {
  const TextFieldStyle({
    super.key,
    required this.controller,
    required this.htext,
    this.maxLine,
  });

  final TextEditingController controller;
  final String htext;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: context.textTheme.bodySmall,
      controller: controller,
      maxLines: maxLine,
      decoration: InputDecoration(
        hintText: htext,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.s12r),
          borderSide: BorderSide(
            color: context.colorScheme.onPrimary,
            width: Sizes.s1AndHalfw,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.s12r),
          borderSide: BorderSide(
            color: context.colorScheme.primary,
            width: Sizes.s2w,
          ),
        ),
      ),
    );
  }
}
