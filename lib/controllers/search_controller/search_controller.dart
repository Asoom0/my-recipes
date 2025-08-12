import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  void searchRecipes(String query) async {
    emit(SearchLoading());

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("recipes")
          .orderBy("createdAt", descending: true)
          .get();

      final allRecipes = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      await Future.delayed(const Duration(milliseconds: 300));

      final filtered = allRecipes.where((recipe) {
        final name = recipe['recipeName']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();

      emit(SearchSuccess(filtered));
    } catch (e) {
      emit(SearchFailure('search.error'.tr()));
    }
  }

  void clearSearchResults() {
    emit(SearchInitial());
  }
}

//--------------- States ----------------
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Map<String, dynamic>> recipes;
  SearchSuccess(this.recipes);
}

class SearchFailure extends SearchState {
  final String errorMessage;
  SearchFailure(this.errorMessage);
}
