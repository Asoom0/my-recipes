import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

class RecipeCubit extends Cubit<RecipesState> {
  RecipeCubit() : super(RecipeInitial());

  Future<void> fetchRecipesByCategory(String categoryKey) async {
    emit(RecipeLoading());

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .where('category', isEqualTo: categoryKey)
          .orderBy('createdAt', descending: true)
          .get();

      final recipes = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      emit(RecipeSuccess(recipes));
    } catch (e) {
      emit(RecipeFailure('add_recipe.error_add_failed'.tr()));
    }
  }
}

//--------------- States ----------------
abstract class RecipesState {}

class RecipeInitial extends RecipesState {}

class RecipeLoading extends RecipesState {}

class RecipeSuccess extends RecipesState {
  final List<Map<String, dynamic>> recipes;

  RecipeSuccess(this.recipes);
}

class RecipeFailure extends RecipesState {
  final String message;

  RecipeFailure(this.message);
}
