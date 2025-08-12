import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future resetPassword(String email) async {
    emit(ResetPasswordLoading());

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(ResetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(
        ResetPasswordFailure(
          e.message ?? 'shared.unknown_error'.tr(),
        ),
      );
    }
  }
}

// ---------------- States ----------------

abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final String errorMessage;
  ResetPasswordFailure(this.errorMessage);
}
