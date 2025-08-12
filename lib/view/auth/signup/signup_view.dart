import 'package:my_recipes/controllers/auth_controller/signup_controller/signup_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/view/auth/login/login_view.dart';
import 'package:my_recipes/view/home_screen/home_screen.dart';
import 'package:my_recipes/home/widgets/text_field_style.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _signup() {
    context.read<SignupCubit>().SignupWithEmailAndPassword(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('signup.app_bar'.tr()),
      ),
      body: SafeArea(
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupLoading) {
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

              if (state is SignupSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      'signup.successful'.tr(),
                      style: TextStyle(color: context.colorScheme.tertiary),
                    ),
                  ),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) =>  HomeScreen()),
                );
              } else if (state is SignupFailure) {
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
                    SizedBox(height: Sizes.s100h),
                    Text(
                      'signup.welcome'.tr(),
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: Sizes.s30h),
                    NameTextField(
                      controller: nameController,
                      icon: Icons.person,
                    ),
                    SizedBox(height: Sizes.s20h),
                    EmailTextField(
                      controller: emailController,
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: Sizes.s20h),
                    PasswordTextField(controller: passwordController),
                    SizedBox(height: Sizes.s50h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        padding: EdgeInsets.zero, // أفضل إزالة padding عشان نتحكم بالحجم من الحجم الثابت
                        fixedSize: Size(Sizes.s250w, Sizes.s45h),
                      ),
                      onPressed: _signup,
                      child: Center(
                        child: Text(
                          'shared.signup'.tr(),
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
                    SizedBox(height: Sizes.s25h),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginView()),
                        );
                      },
                      child: Text(
                        'signup.goto_login_text'.tr(),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface,
                          decoration: TextDecoration.underline,
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
