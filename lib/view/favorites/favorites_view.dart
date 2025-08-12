import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_recipes/controllers/favorites_controller/favorites_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
//import 'package:my_recipes/core/strings/strings.dart';
import 'package:my_recipes/home/widgets/recipe_card.dart';
import 'package:my_recipes/view/recipe_details/recipe_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavoritesPage();
  }
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'favorites.app_bar'.tr(),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<FavoritesCubit, List<Map<String, dynamic>>>(
          builder: (context, favorites) {
            if (favorites.isEmpty) {
              return Center(child: Text('favorites.empty'.tr()));
            }
            return Padding(
              padding: EdgeInsets.all(Sizes.s16w),
              child: GridView.builder(
                itemCount: favorites.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.80,
                ),
                itemBuilder: (context, index) {
                  final recipe = favorites[index];

                  return RecipeCard(
                    recipes: recipe,
                    isFavorite: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetails(data: recipe),
                        ),
                      );
                    },
                    onBookmarkPressed: () {
                      final favoritesCubit = context.read<FavoritesCubit>();
                      final isFav = favoritesCubit.isFavorite(recipe);
                      favoritesCubit.toggleFavorite(recipe);

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
        ),
      ),
      //bottomNavigationBar: NavigationBarView(),
    );
  }
}
