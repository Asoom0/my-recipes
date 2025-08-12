import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_recipes/core/storage/shared_prefs_helper.dart';

// -------------------- Cubit --------------------
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  StreamSubscription? _recipesSubscription;

  void fetchRecipes() {
    emit(HomeLoading());

    _recipesSubscription?.cancel();

    _recipesSubscription = FirebaseFirestore.instance
        .collection("recipes")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((snapshot) {
      final allDocs = snapshot.docs;

      final latestRecipes = allDocs.take(4).map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      final allRecipes = allDocs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      final randomRecipes = List<Map<String, dynamic>>.from(allRecipes);
      randomRecipes.shuffle();

      final userName = SharedPrefsHelper().getString('name') ?? 'User';

      emit(HomeSuccess(
        randomRecipes: randomRecipes.take(6).toList(),
        latestRecipes: latestRecipes,
        userName: userName,
      ));
    }, onError: (_) {
      emit(HomeFailure('home.error'.tr()));
    });
  }

  Future<void> filterByCategory(String categoryName) async {
    emit(HomeLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("recipes")
          .where("category", isEqualTo: categoryName)
          .orderBy("createdAt", descending: true)
          .get();

      final filtered = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      final userName = SharedPrefsHelper().getString('name') ?? "User";

      emit(HomeSuccess(
        randomRecipes: const [],
        latestRecipes: filtered,
        userName: userName,
      ));
    } catch (e) {
      emit(HomeFailure('home.error'.tr()));
    }
  }

  void updateSingleRecipe(Map<String, dynamic> updatedRecipe) {
    if (state is HomeSuccess) {
      final currentState = state as HomeSuccess;

      // تحديث latestRecipes
      final updatedLatest = currentState.latestRecipes.map((recipe) {
        if (recipe['id'] == updatedRecipe['id']) {
          return updatedRecipe;
        }
        return recipe;
      }).toList();

      // تحديث randomRecipes
      final updatedRandom = currentState.randomRecipes.map((recipe) {
        if (recipe['id'] == updatedRecipe['id']) {
          return updatedRecipe;
        }
        return recipe;
      }).toList();

      emit(HomeSuccess(
        latestRecipes: updatedLatest,
        randomRecipes: updatedRandom,
        userName: currentState.userName,
      ));
    }
  }

  @override
  Future<void> close() {
    _recipesSubscription?.cancel();
    return super.close();
  }
}

//--------------- States ----------------
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Map<String, dynamic>> randomRecipes;
  final List<Map<String, dynamic>> latestRecipes;
  final String userName;

  HomeSuccess({
    required this.randomRecipes,
    required this.latestRecipes,
    required this.userName,
  });
}

class HomeFailure extends HomeState {
  final String errorMessage;
  HomeFailure(this.errorMessage);
}
