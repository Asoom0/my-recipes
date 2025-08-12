import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_recipes/core/storage/shared_prefs_helper.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchUserData() async {
    emit(ProfileLoading());
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(ProfileSuccess(
        name: 'profile.guest_user'.tr(),
        email: 'profile.no_email'.tr(),
        imageUrl: null,
      ));
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();

    emit(ProfileSuccess(
      name: data?['name'] ?? 'profile.no_name'.tr(),
      email: data?['email'] ?? 'profile.no_email'.tr(),
      imageUrl: data?['imageUrl'],
    ));
  }

  Future<void> updateUserName(String newName, {VoidCallback? onUpdated}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      // حدّث Firestore أولًا
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'name': newName});

      // لو نجح، حدّث SharedPrefs
      await SharedPrefsHelper().setString('name', newName);

      // حدث ال state
      final current = state;
      if (current is ProfileSuccess) {
        emit(current.copyWith(name: newName));
      }

      // نادِ callback بعد التحديث
      if (onUpdated != null) onUpdated();
    } catch (e) {
      // ممكن تضيف هنا emit لفشل التحديث
      emit(ProfileFailure('profile.error_update_name'.tr()));
    }
  }


  Future<void> updateProfilePhoto(File imageFile) async {
    emit(ProfileLoading());
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      // رفع الصورة إلى Storage
      final ref = FirebaseStorage.instance.ref().child('profile_photos/$uid.jpg');
      await ref.putFile(imageFile);

      // الحصول على رابط الصورة
      final imageUrl = await ref.getDownloadURL();

      // تحديث رابط الصورة في Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'imageUrl': imageUrl,
      });

      final current = state;
      if (current is ProfileSuccess) {
        emit(current.copyWith(imageUrl: imageUrl));
      } else {
        await fetchUserData();
      }
    } catch (e) {
      emit(ProfileFailure('profile.error_upload_photo'.tr()));
    }
  }
}

//--------------- States ----------------
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final String name;
  final String email;
  final String? imageUrl;
  ProfileSuccess({
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  ProfileSuccess copyWith({String? name, String? email, String? imageUrl}) =>
      ProfileSuccess(
        name: name ?? this.name,
        email: email ?? this.email,
        imageUrl: imageUrl ?? this.imageUrl,
      );
}

class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);
}
