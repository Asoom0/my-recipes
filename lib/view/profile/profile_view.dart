import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipes/controllers/profile_controller/profile_controller.dart';
import 'package:my_recipes/controllers/theme_controller/theme_controller.dart';
import 'package:my_recipes/controllers/user_controoler/user_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
//import 'package:my_recipes/core/strings/strings.dart';
import 'package:my_recipes/core/storage/shared_prefs_helper.dart';
import 'package:my_recipes/home/widgets/icon_design.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:my_recipes/view/auth/login/login_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/home_controller/home_controller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _pickedImage;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      setState(() {
        _pickedImage = file;
      });

      // استدعاء الكيوبت لرفع الصورة وتحديث البيانات
      context.read<ProfileCubit>().updateProfilePhoto(file);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('profile.app_bar'.tr()),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Sizes.s10w),
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is ProfileSuccess && _pickedImage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('profile.photo_saved'.tr())),
                );
                _pickedImage = null; // مسح الصورة بعد الحفظ
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileSuccess) {
                return Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _pickAndUploadImage,
                          child: CircleAvatar(
                            radius: Sizes.s40r,
                            backgroundColor: context.colorScheme.primaryContainer,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage!)
                                : (state.imageUrl != null && state.imageUrl!.isNotEmpty
                                ? NetworkImage(state.imageUrl!)
                                : null) as ImageProvider<Object>?,
                            child: (state.imageUrl == null && _pickedImage == null)
                                ? Icon(
                              Icons.image,
                              size: Sizes.s30w,
                              color: context.colorScheme.primary,
                            )
                                : null,
                          ),
                        ),
                        SizedBox(width: Sizes.s16w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<UserCubit, String>(
                              builder: (context, userName) {
                                return Text(userName, style: context.textTheme.bodyLarge);
                              },
                            ),
                            SizedBox(height: Sizes.s4h),
                            Text(
                              state.email,
                              style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Sizes.s30h),
                    ListTile(
                      leading: IconDesign(icon: Icons.edit),
                      title: Text('profile.edit_name'.tr()),
                      onTap: () async {
                        final currentName = context.read<UserCubit>().state;
                        final controller = TextEditingController(text: currentName);
                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('profile.edit_name'.tr()),
                            content: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                hintText: 'profile.enter_new_name'.tr(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'profile.cancel'.tr(),
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final newName = controller.text.trim();
                                  if (newName.isNotEmpty) {
                                      context.read<UserCubit>().updateUserName(newName);
                                  }
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'profile.save'.tr(),
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: IconDesign(icon: Icons.dark_mode),
                      title: Text('profile.dark_mode'.tr()),
                      trailing: Switch(
                        value: isDark,
                        onChanged: (val) {
                          context.read<ThemeCubit>().toggleTheme(val);
                        },
                      ),
                    ),
                    ListTile(
                      leading: IconDesign(icon: Icons.language),
                      title: Text('profile.change_language'.tr()),
                      trailing: Text(
                        context.locale.languageCode == 'ar' ? 'العربية' : 'English',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        final currentLocale = context.locale;
                        if (currentLocale.languageCode == 'ar') {
                          context.setLocale(const Locale('en'));
                        } else {
                          context.setLocale(const Locale('ar'));
                        }
                      },
                    ),
                    ListTile(
                      leading: IconDesign(icon: Icons.logout),
                      title: Text('profile.sign_out'.tr()),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        SharedPrefsHelper().clear();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginView()),
                              (_) => false,
                        );
                      },
                    ),
                    ListTile(
                      leading: IconDesign(icon: Icons.delete_forever),
                      title: Text('profile.delete_account'.tr()),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('profile.delete_confirm_title'.tr()),
                            content: Text('profile.delete_confirm_content'.tr()),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  'profile.cancel'.tr(),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  'profile.delete_account'.tr(),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            try {
                              await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
                              await user.delete();
                              SharedPrefsHelper().clear();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const LoginView()),
                                    (_) => false,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('profile.delete_failed'.tr())),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                );
              } else if (state is ProfileFailure) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
