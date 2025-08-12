import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipes/core/strings/strings.dart';

class AddRecipeCategoriesUpdated extends AddRecipeState {
  final List<Map<String, dynamic>> categories;
  AddRecipeCategoriesUpdated(this.categories);
}

class AddRecipeCubit extends Cubit<AddRecipeState> {
  AddRecipeCubit() : super(AddRecipeInitial());

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
    emit(AddRecipeCategoriesUpdated(_defaultCategories));
  }

  Future<void> addRecipe(
      String recipeName,
      String category,
      String ingredients,
      String instructions,
      String? imageUrl,
      ) async {
    if (recipeName.isEmpty ||
        category.isEmpty ||
        ingredients.isEmpty ||
        instructions.isEmpty) {
      emit(AddRecipeFailure('add_recipe.error_empty_fields'.tr()));
      return;
    }

    emit(AddRecipeLoading());

    try {
      await FirebaseFirestore.instance.collection("recipes").add({
        'recipeName': recipeName,
        'category': category,
        'ingredients': ingredients,
        'instructions': instructions,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
      });

      emit(AddRecipeSuccess());
    } catch (e) {
      emit(AddRecipeFailure('add_recipe.error_add_failed'.tr()));
    }
  }
}

//--------------- States ----------------
abstract class AddRecipeState {}

class AddRecipeInitial extends AddRecipeState {}

class AddRecipeLoading extends AddRecipeState {}

class AddRecipeSuccess extends AddRecipeState {}

class AddRecipeFailure extends AddRecipeState {
  final String errorMessage;
  AddRecipeFailure(this.errorMessage);
}
