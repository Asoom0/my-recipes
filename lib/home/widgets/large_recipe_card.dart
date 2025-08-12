import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/view/recipe_details/recipe_details_view.dart';
import 'package:my_recipes/utils/extensions.dart';

class LargeRecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;

  LargeRecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizes.s10w),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RecipeDetails(data: recipe)),
        ),
        child: Container(
          padding: EdgeInsets.all(Sizes.s6w),
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(Sizes.s12r),
            border: Border.all(
              color: context.colorScheme.primary,
              width: Sizes.s1AndHalfw,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: Sizes.s6r,
                offset: Offset(0, Sizes.s4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Sizes.s6w),
                child: Image.asset(
                  recipe['image'] ?? "assets/images/${recipe['category']}.png",
                  height: Sizes.s200h,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Text(
                recipe['recipeName'] ?? 'details.no_name'.tr(),
                style: context.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );

  }
}
