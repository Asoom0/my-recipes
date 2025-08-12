import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipes/controllers/recipes_controller/recipes_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:my_recipes/view/recipes_view/recipes_view.dart';


class CircularCategoryCard extends StatelessWidget {
  final String categoryKey;
  final String name;
  final String image;


  CircularCategoryCard({
    required this.categoryKey,
    required this.name,
    required this.image,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.s100w,
      margin: EdgeInsets.symmetric(horizontal: Sizes.s4w),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                  MaterialPageRoute(
                  builder: (_) => BlocProvider(
                create: (_) => RecipeCubit()..fetchRecipesByCategory(categoryKey),
                child: RecipesView(categoryName: name),
                ),
               ),
              );
            },
            child: Container(
              width: Sizes.s85w,
              height: Sizes.s85h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colorScheme.primary,
                  width: Sizes.s1w,
                ),
              ),
              child:  CircleAvatar(
                radius: Sizes.s40r,
                backgroundColor: context.colorScheme.primaryContainer,
                child: Image.asset(image,
                  width: Sizes.s65w,
                  height: Sizes.s65h,
                  fit: BoxFit.cover,),
              ),
            ),
          ),
          SizedBox(height: Sizes.s6h),
          Text(name),
        ],
      ),
    );
  }
}
