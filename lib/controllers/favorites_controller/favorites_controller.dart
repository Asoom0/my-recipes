import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<List<Map<String, dynamic>>> {
  FavoritesCubit() : super([]);

  void toggleFavorite(Map<String, dynamic> recipe) {
    final current = List<Map<String, dynamic>>.from(state);

    final exists = current.any((element) => element['id'] == recipe['id']);

    if (exists) {
      current.removeWhere((element) => element['id'] == recipe['id']);
    } else {
      current.add(recipe);
    }

    emit(current);
  }

  void removeFavorite(Map<String, dynamic> recipe) {
    final current = List<Map<String, dynamic>>.from(state);
    current.removeWhere((element) => element['id'] == recipe['id']);
    emit(current);
  }
  void updateFavorite(Map<String, dynamic> updateRecipe) {
    final id = updateRecipe['id'];
    final index = state.indexWhere((recipe) => recipe['id'] == id);

    if (index != -1) {
      final updatedFavorites = List<Map<String, dynamic>>.from(state);
      updatedFavorites[index] = updateRecipe;
      emit(updatedFavorites);
    }
  }




  bool isFavorite(Map<String, dynamic> post) {
    return state.any((element) => element['id'] == post['id']);
  }
}