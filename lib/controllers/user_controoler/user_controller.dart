import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipes/core/storage/shared_prefs_helper.dart';

class UserCubit extends Cubit<String> {
  UserCubit() : super("User") {
    loadUserName();
  }

  Future<void> loadUserName() async {
    final name = SharedPrefsHelper().getString('name') ?? "User";
    emit(name);
  }

  Future<void> updateUserName(String newName) async {
    await SharedPrefsHelper().setString('name', newName);
    emit(newName);
  }
}
