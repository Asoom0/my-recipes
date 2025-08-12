import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_recipes/core/storage/shared_prefs_helper.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  Future<void> SignupWithEmailAndPassword(String name, String email, String password) async {
    emit(SignupLoading());
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
      });

      await SharedPrefsHelper().setString("userEmail", email);
      await SharedPrefsHelper().setString("name", name);

      emit(SignupSuccess());
    } on FirebaseAuthException catch (e) {
      emit(
        SignupFailure(
          e.message ?? 'shared.unknown_error'.tr(),
        ),
      );
    }
  }
}

// ---------------- States ----------------

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String errorMessage;
  SignupFailure(this.errorMessage);
}
