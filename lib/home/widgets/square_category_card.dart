import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipes/controllers/recipes_controller/recipes_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:my_recipes/view/recipes_view/recipes_view.dart';

class SquareCategoryCard extends StatelessWidget {

  final String categoryKey;
  final String text;
  final String imagePath;

  SquareCategoryCard({
    super.key,
    required this.categoryKey,
    required this.text,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => RecipeCubit()..fetchRecipesByCategory(categoryKey),
              child: RecipesView(categoryName: text),
            ),
          ),
        );
      },
      child: Container(
        height: Sizes.s185h,
        width: Sizes.s160w,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color: context.colorScheme.secondary,
              width: Sizes.s2w),
          borderRadius: BorderRadius.circular(Sizes.s12r),
          color: context.colorScheme.secondaryContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.s10r),
              child: Image.asset(
                imagePath,
                width: Sizes.s120w,
                height: Sizes.s120h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: Sizes.s15h),
            Text(
              text,
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
      ),
    );
  }
}
