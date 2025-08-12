import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/storage/shared_prefs_helper.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(LoginLoading());

    try {
      // Sign in with Firebase Auth
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        emit(LoginFailure('login.failed_to_retrieve'.tr()));
        return;
      }

      // Fetch user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final userData = userDoc.data();
      if (userData == null) {
        emit(LoginFailure('login.user_not_found'.tr()));
        return;
      }

      final userName = userData['name'] ?? 'User';

      // Save data to local storage
      await SharedPrefsHelper().setString("userEmail", email);
      await SharedPrefsHelper().setString("name", userName);

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? 'login.unknown_error'.tr()));
    } catch (e) {
      emit(LoginFailure("Server error: ${e.toString()}"));
    }
  }
}

//--------------- States ----------------

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}
