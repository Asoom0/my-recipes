import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_recipes/core/storage/shared_prefs_helper.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/view/auth/login/login_view.dart';
import 'package:my_recipes/view/auth/signup/signup_view.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Sizes.s8w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Sizes.s50h),
                Container(
                  padding: EdgeInsets.all(Sizes.s35w),
                  width: Sizes.s350w,
                  height: Sizes.s350h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.secondary,
                  ),
                  child: Lottie.asset(
                    'assets/animations/intro.json',
                    width: Sizes.s100w,
                    height: Sizes.s100h,
                  ),
                ),
                SizedBox(height: Sizes.s25h),

                // My Recipes title
                Text('app_name'.tr(), style: context.textTheme.headlineLarge),

                SizedBox(height: Sizes.s10h),

                // Description
                Text(
                  'intro.description'.tr(),
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: Sizes.s60h),

                // Signup Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        padding: EdgeInsets.zero, // أفضل إزالة padding عشان نتحكم بالحجم من الحجم الثابت
                        fixedSize: Size(Sizes.s250w, Sizes.s45h),
                      ),
                      onPressed: () async {
                        await SharedPrefsHelper().setBool('hasSeenIntro', true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupView()),
                        );
                      },

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
                  ],
                ),

                SizedBox(height: Sizes.s20h),

                // Login Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        padding: EdgeInsets.zero, // أفضل إزالة padding عشان نتحكم بالحجم من الحجم الثابت
                        fixedSize: Size(Sizes.s250w, Sizes.s45h),
                       ),
                      onPressed: () async {
                        await SharedPrefsHelper().setBool('hasSeenIntro', true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginView()),
                        );
                      },

                      child: Center(
                        child: Text(
                          'shared.login'.tr(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
