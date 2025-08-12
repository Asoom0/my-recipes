import 'package:my_recipes/controllers/add_recipe_controller/add_recipe_controller.dart';
import 'package:my_recipes/controllers/auth_controller/reset_password_controller/reset_password_controller.dart';
import 'package:my_recipes/controllers/auth_controller/signup_controller/signup_controller.dart';
import 'package:my_recipes/controllers/recipe_details_controller/recipe_details_controller.dart';
import 'package:my_recipes/controllers/recipes_controller/recipes_controller.dart';
import 'package:my_recipes/controllers/home_controller/home_controller.dart';
import 'package:my_recipes/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:my_recipes/controllers/profile_controller/profile_controller.dart';
import 'package:my_recipes/controllers/search_controller/search_controller.dart';
import 'package:my_recipes/controllers/theme_controller/theme_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_recipes/controllers/user_controoler/user_controller.dart';
import 'package:my_recipes/core/storage/shared_prefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipes/view/intro_view/intro_view.dart';
import 'config/theme/app_theme.dart';
import 'controllers/auth_controller/login_controller/login_controller.dart';
import 'controllers/favorites_controller/favorites_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'view/auth/AuthWrapper/authWrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefsHelper().init();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  await EasyLocalization.ensureInitialized(); // ← إضافة مهمة

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations', // ← مكان ملفات الترجمة
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => UserCubit()),
          BlocProvider(create: (_) => LoginCubit()),
          BlocProvider(create: (_) => SignupCubit()),
          BlocProvider(create: (_) => ResetPasswordCubit()),
          BlocProvider(create: (_) => FavoritesCubit()),
          BlocProvider(create: (_) => HomeScreenCubit()),
          BlocProvider(create: (_) => HomeCubit()),
          BlocProvider(create: (_) => RecipeCubit()),
          BlocProvider(create: (_) => AddRecipeCubit()),
          BlocProvider(create: (_) => RecipeDetailsCubit()),
          BlocProvider(create: (_) => SearchCubit()),
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => ProfileCubit()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) {
            return const MyApp();
          },
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return MaterialApp(
          theme: AppTheme.light(context),
          darkTheme: AppTheme.dark(context),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          locale: context.locale, // ← جديد
          supportedLocales: context.supportedLocales, // ← جديد
          localizationsDelegates: context.localizationDelegates, // ← جديد
          home: const AuthWrapper(),
        );
      },
    );
  }
}
