import 'package:my_recipes/controllers/favorites_controller/favorites_controller.dart';
import 'package:my_recipes/controllers/user_controoler/user_controller.dart';
import 'package:my_recipes/home/widgets/circular_category_card.dart';
import 'package:my_recipes/home/widgets/recipe_card.dart';
import 'package:my_recipes/view/recipe_details/recipe_details_view.dart';
import 'package:my_recipes/view/add_recipe/add_recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipes/controllers/home_controller/home_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
//import 'package:my_recipes/core/strings/strings.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeView extends StatelessWidget {
  final void Function(int)? onTabChange;
  const HomeView({super.key, this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: HomePage(onTabChange: onTabChange),
    );
  }
}

class HomePage extends StatefulWidget {
  final void Function(int)? onTabChange;
  const HomePage({super.key, this.onTabChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: BlocBuilder<UserCubit, String>(
          builder: (context, userName) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${'home.hello'.tr()} $userName',
                      style: context.textTheme.headlineMedium,
                    ),
                  ],
                ),
                SizedBox(height: Sizes.s4h),
                Row(
                  children: [
                    Text(
                      'home.app_bar'.tr(),
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (_, state) {
            if (state is HomeLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: context.colorScheme.primary,
                ),
              );
            } else if (state is HomeSuccess) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(Sizes.s16w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'home.categories'.tr(),
                              style: context.textTheme.headlineMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                widget.onTabChange?.call(1);
                              },
                              child: Text(
                                'home.view_all'.tr(),
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Sizes.s10h),
                        SizedBox(
                          height: Sizes.s120h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              CircularCategoryCard(
                                categoryKey: 'Breakfast',
                                name: 'home.breakfast'.tr(),
                                image: "assets/images/Breakfast.png",
                              ),
                              CircularCategoryCard(
                                categoryKey: 'Meal',
                                name: 'home.meal'.tr(),
                                image: "assets/images/Meal.png",
                              ),
                              CircularCategoryCard(
                                categoryKey: 'Salad',
                                name: 'home.salad'.tr(),
                                image: "assets/images/Salad.png",
                              ),
                              CircularCategoryCard(
                                categoryKey: 'Dessert',
                                name: 'home.dessert'.tr(),
                                image: "assets/images/Dessert.png",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Sizes.s15h),

                        // ====== For You ======
                        Row(
                          children: [
                            Text(
                              'home.for_you'.tr(),
                              style: context.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                        SizedBox(height: Sizes.s15h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.randomRecipes.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 0.80,
                          ),
                          itemBuilder: (_, index) {
                            final recipe = state.randomRecipes[index];

                            return BlocBuilder<FavoritesCubit,
                                List<Map<String, dynamic>>>(
                              builder: (context, favState) {
                                final favCubit = context.read<FavoritesCubit>();
                                final isFav = favCubit.isFavorite(recipe);

                                return RecipeCard(
                                  key: ValueKey(recipe['id']),
                                  recipes: recipe,
                                  isFavorite: isFav,
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            RecipeDetails(data: recipe),
                                      ),
                                    );

                                    final homeCubit = context.read<HomeCubit>();

                                    if (result == 'deleted') {
                                      homeCubit.fetchRecipes();
                                    } else if (result is Map<String, dynamic>) {
                                      homeCubit.updateSingleRecipe(result);
                                    }
                                  },
                                  onBookmarkPressed: () {
                                    favCubit.toggleFavorite(recipe);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isFav
                                              ? 'favorites.removed'
                                              .tr()
                                              : 'favorites.added'
                                              .tr(),
                                        ),
                                        backgroundColor:
                                        isFav ? Colors.red : Colors.green,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: Sizes.s15h),
                        Row(
                          children: [
                            Text(
                              'home.latest'.tr(),
                              style: context.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                        SizedBox(height: Sizes.s15h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.latestRecipes.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 0.80,
                          ),
                          itemBuilder: (_, index) {
                            final recipe = state.latestRecipes[index];

                            return BlocBuilder<FavoritesCubit,
                                List<Map<String, dynamic>>>(
                              builder: (context, favState) {
                                final favCubit = context.read<FavoritesCubit>();
                                final isFav = favCubit.isFavorite(recipe);

                                return RecipeCard(
                                  key: ValueKey(recipe['id']),
                                  recipes: recipe,
                                  isFavorite: isFav,
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            RecipeDetails(data: recipe),
                                      ),
                                    );

                                    final homeCubit = context.read<HomeCubit>();

                                    if (result == 'deleted') {
                                      homeCubit.fetchRecipes();
                                    } else if (result is Map<String, dynamic>) {
                                      homeCubit.updateSingleRecipe(result);
                                    }
                                  },

                                  onBookmarkPressed: () {
                                    favCubit.toggleFavorite(recipe);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isFav
                                              ? 'favorites.removed'
                                              .tr()
                                              : 'favorites.added'
                                              .tr(),
                                        ),
                                        backgroundColor:
                                        isFav ? Colors.red : Colors.green,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is HomeFailure) {
              return Center(child: Text(state.errorMessage));
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final cubit = context.read<HomeCubit>();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AddRecipeView()))
              .then((_) {
            cubit.fetchRecipes();
          });
        },
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.s16r),
          side: BorderSide(
            color: context.colorScheme.tertiary,
            width: Sizes.sZeroAndHalf,
          ),
        ),
        child: Icon(Icons.add, size: Sizes.s30w),
      ),
    );
  }
}
