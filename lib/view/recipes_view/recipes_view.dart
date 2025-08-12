import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_recipes/controllers/recipes_controller/recipes_controller.dart';
import 'package:my_recipes/controllers/favorites_controller/favorites_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
//import 'package:my_recipes/core/strings/strings.dart';
import 'package:my_recipes/home/widgets/recipe_card.dart';
import 'package:my_recipes/view/recipe_details/recipe_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
class RecipesView extends StatelessWidget {
  final String categoryName;

  const RecipesView({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipeCubit()..fetchRecipesByCategory(categoryName),
      child: _RecipesViewContent(categoryName: categoryName),
    );
  }
}

class _RecipesViewContent extends StatelessWidget {
  final String categoryName;

  const _RecipesViewContent({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: SafeArea(
        child: BlocBuilder<RecipeCubit, RecipesState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipeSuccess) {
              final recipes = state.recipes;

              if (recipes.isEmpty) {
                return Center(child: Text('shared.no_recipe'.tr()));
              }
              return BlocBuilder<FavoritesCubit, List<Map<String, dynamic>>>(
                builder: (_, favorites) {
                  return Padding(
                    padding: EdgeInsets.all(Sizes.s16w),
                    child: GridView.builder(
                      itemCount: recipes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.80,
                      ),
                      itemBuilder: (_, index) {
                        final recipe = recipes[index];
                        final favCubit = context.read<FavoritesCubit>();
                        final isFav = favCubit.isFavorite(recipe);
                        return RecipeCard(
                          key: ValueKey(recipe['id']),
                          isFavorite: isFav,
                          recipes: recipe,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipeDetails(data: recipe),
                              ),
                            );
                            if (result == 'deleted') {
                              context.read<RecipeCubit>().fetchRecipesByCategory(categoryName);
                            }
                          },
                          onBookmarkPressed: () {
                            favCubit.toggleFavorite(recipe);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFav
                                      ? 'favorites.removed'.tr()
                                      : 'favorites.added'.tr(),
                                ),
                                backgroundColor: isFav ? Colors.red : Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is RecipeFailure) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
