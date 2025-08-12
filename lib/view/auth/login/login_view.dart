import 'package:my_recipes/controllers/auth_controller/login_controller/login_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/core/storage/shared_prefs_helper.dart';
import 'package:my_recipes/view/home_screen/home_screen.dart';
import 'package:my_recipes/home/widgets/text_field_style.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:my_recipes/view/auth/resetPassword/reset_password_view.dart';
import 'package:my_recipes/view/auth/signup/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = SharedPrefsHelper().getString('name');
    setState(() {
      userName = name ?? "User";
    });
  }

  void _login() {
    context.read<LoginCubit>().loginWithEmailAndPassword(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("login.app_bar".tr()),
      ),
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
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
              // Remove dialog if open
              Navigator.of(context, rootNavigator: true).pop();

              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      "login.successful".tr(),
                      style: TextStyle(color: context.colorScheme.tertiary),
                    ),
                  ),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(),
                  ),
                );
              } else if (state is LoginFailure) {
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
                      "login.welcome_back".tr(),
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: Sizes.s30h),
                    EmailTextField(
                      controller: emailController,
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: Sizes.s20h),
                    PasswordTextField(
                      controller: passwordController,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ResetPassword(),
                          ),
                        );
                      },
                      child: Text(
                        "login.forgot_password".tr(),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: Sizes.s40h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        padding: EdgeInsets.zero, // أفضل إزالة padding عشان نتحكم بالحجم من الحجم الثابت
                        fixedSize: Size(Sizes.s250w, Sizes.s45h), // هنا تحدد العرض والارتفاع ثابتا
                      ),
                      onPressed: _login,
                      child: Center(
                        child: Text(
                          "shared.login".tr(),
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
                    SizedBox(height: Sizes.s13h),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const Signup(),
                          ),
                        );
                      },
                      child: Text(
                        "login.goto_signup_text".tr(),
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
