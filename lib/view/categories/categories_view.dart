import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/core/strings/strings.dart';
import 'package:my_recipes/home/widgets/square_category_card.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('categories.app_bar'.tr()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Sizes.s20w),
          child: Column(
            children: [
              _buildRow([
                SquareCategoryCard(
                  categoryKey: 'Meal',
                  text: 'categories.meal'.tr(),
                  imagePath: 'assets/images/Meal.png',
                ),
                SquareCategoryCard(
                  categoryKey: 'Breakfast',
                  text: 'categories.breakfast'.tr(),
                  imagePath: 'assets/images/Breakfast.png',
                ),
              ]),
              SizedBox(height: Sizes.s20h),
              _buildRow([
                SquareCategoryCard(
                  categoryKey: 'Salad',
                  text: 'categories.salad'.tr(),
                  imagePath: 'assets/images/Salad.png',
                ),
                SquareCategoryCard(
                  categoryKey: 'Soup',
                  text: 'categories.soup'.tr(),
                  imagePath: 'assets/images/Soup.png',
                ),
              ]),
              SizedBox(height: Sizes.s20h),
              _buildRow([
                SquareCategoryCard(
                  categoryKey: 'Cake',
                  text: 'categories.cake'.tr(),
                  imagePath: 'assets/images/Cake.png',
                ),
                SquareCategoryCard(
                  categoryKey: 'Bakery',
                  text: 'categories.bakery'.tr(),
                  imagePath: 'assets/images/Bakery.png',
                ),
              ]),
              SizedBox(height: Sizes.s20h),
              _buildRow([
                SquareCategoryCard(
                  categoryKey: 'Dessert',
                  text: 'categories.dessert'.tr(),
                  imagePath: 'assets/images/Dessert.png',
                ),
                SquareCategoryCard(
                  categoryKey: 'Juice',
                  text: 'categories.juice'.tr(),
                  imagePath: 'assets/images/Juice.png',
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
