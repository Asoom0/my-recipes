import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/core/storage/shared_prefs_helper.dart';
import 'package:my_recipes/view/auth/login/login_view.dart';
import 'package:my_recipes/view/home_screen/home_screen.dart';
import 'package:my_recipes/view/intro_view/intro_view.dart';
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool? hasSeenIntro;

  @override
  void initState() {
    super.initState();
    checkIntroSeen();
  }

  Future<void> checkIntroSeen() async {
    final seen = await SharedPrefsHelper().getBool('hasSeenIntro') ?? false;
    setState(() {
      hasSeenIntro = seen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasSeenIntro == null) {
      // لا زلنا ننتظر التحقق
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!hasSeenIntro!) {
      // لم يشاهد الانتر بعد
      return IntroView();
    }

    // إذا شاهد الانتر، نتحقق من حالة المستخدم
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
