import 'package:my_recipes/controllers/auth_controller/reset_password_controller/reset_password_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/home/widgets/text_field_style.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_recipes/view/auth/login/login_view.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(),
      child: const ResetPasswordView(),
    );
  }
}

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final emailController = TextEditingController();

  void _resetPassword() {
    context.read<ResetPasswordCubit>().resetPassword(
      emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('reset_password.app_bar'.tr())),
      body: SafeArea(
        child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Center(
                  child: CircularProgressIndicator(
                    color: context.colorScheme.primary,
                  ),
                ),
              );
            } else {
              Navigator.of(context, rootNavigator: true).pop();

              if (state is ResetPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      'reset_password.email_sent'.tr(),
                      style: TextStyle(color: context.colorScheme.tertiary),
                    ),
                  ),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const Login()),
                );
              } else if (state is ResetPasswordFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      state.errorMessage,
                      style: TextStyle(color: context.colorScheme.tertiary),
                    ),
                  ),
                );
              }
            }
          },
          builder: (_, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Sizes.s20w),
                child: Column(
                  children: [
                    SizedBox(height: Sizes.s50h),
                    Text(
                      'reset_password.hint'.tr(),
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Sizes.s40h),
                    EmailTextField(
                      controller: emailController,
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: Sizes.s40h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        padding: EdgeInsets.zero, // أفضل إزالة padding عشان نتحكم بالحجم من الحجم الثابت
                        fixedSize: Size(Sizes.s250w, Sizes.s45h),
                      ),
                      onPressed: _resetPassword,
                      child: Center(
                        child: Text(
                          'reset_password.button'.tr(),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.tertiary,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
