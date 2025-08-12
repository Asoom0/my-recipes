import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easy_localization/easy_localization.dart';

class RecipeDetailsCategoriesUpdated extends RecipeDetailsState {
  final List<Map<String, dynamic>> categories;
  RecipeDetailsCategoriesUpdated(this.categories);
}

class RecipeDetailsCubit extends Cubit<RecipeDetailsState> {
  RecipeDetailsCubit() : super(RecipeDetailsInitial());

  final List<Map<String, dynamic>> _defaultCategories = [
    {
      'name': 'Meal',
      'image': 'assets/images/Meal.png',
    },
    {
      'name': 'Breakfast',
      'image': 'assets/images/Breakfast.png',
    },
    {
      'name': 'Salad',
      'image': 'assets/images/Salad.png',
    },
    {
      'name': 'Soup',
      'image': 'assets/images/Soup.png',
    },
    {
      'name': 'Cake',
      'image': 'assets/images/Cake.png',
    },
    {
      'name': 'Bakery',
      'image': 'assets/images/Bakery.png',
    },
    {
      'name': 'Dessert',
      'image': 'assets/images/Dessert.png',
    },
    {
      'name': 'Juice',
      'image': 'assets/images/Juice.png',
    },
  ];

  void loadCategories() {
    emit(RecipeDetailsCategoriesUpdated(_defaultCategories));
  }

  Future<void> deleteRecipe(String recipeId) async {
    emit(RecipeDetailsLoading());
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final imageUrl = data?['imageUrl'];

        if (imageUrl != null && imageUrl is String && imageUrl.isNotEmpty) {
          final ref = FirebaseStorage.instance.refFromURL(imageUrl);
          await ref.delete();
        }
      }

      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .delete();

      emit(RecipeDetailsSuccess());
    } catch (e) {
      print("Error deleting: $e");
      emit(RecipeDetailsFailure('details.delete_failed'.tr()));
      rethrow;
    }
  }

  Future<void> updateRecipe({
    required String id,
    required String recipeName,
    required String category,
    required String ingredients,
    required String instructions,
    String? imageUrl,
  }) async {
    emit(RecipeDetailsLoading());
    try {
      await FirebaseFirestore.instance.collection('recipes').doc(id).update({
        'recipeName': recipeName,
        'category': category,
        'ingredients': ingredients,
        'instructions': instructions,
        if (imageUrl != null) 'imageUrl': imageUrl,
        'updatedAt': DateTime.now(),
      });

      final updatedRecipe = {
        'id': id,
        'recipeName': recipeName,
        'category': category,
        'ingredients': ingredients,
        'instructions': instructions,
        'imageUrl': imageUrl,
        'updatedAt': DateTime.now(),
      };

      emit(RecipeDetailsUpdated(updatedRecipe));
    } catch (e) {
      emit(RecipeDetailsFailure('details.update_failed'.tr()));
    }
  }
}

//--------------- States ----------------
abstract class RecipeDetailsState {}

class RecipeDetailsInitial extends RecipeDetailsState {}

class RecipeDetailsLoading extends RecipeDetailsState {}

class RecipeDetailsSuccess extends RecipeDetailsState {}

class RecipeDetailsUpdated extends RecipeDetailsState {
  final Map<String, dynamic> updatedRecipe;
  RecipeDetailsUpdated(this.updatedRecipe);
}

class RecipeDetailsFailure extends RecipeDetailsState {
  final String message;
  RecipeDetailsFailure(this.message);
}
