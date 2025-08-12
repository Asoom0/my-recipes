import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipes/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/core/strings/strings.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:my_recipes/view/categories/categories_view.dart';
import 'package:my_recipes/view/favorites/favorites_view.dart';
import 'package:my_recipes/view/home/home_view.dart';
import 'package:my_recipes/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_recipes/view/search_view/search_view.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeView(
        onTabChange: (index) => context.read<HomeScreenCubit>().goTo(index),
      ),
      const CategoryView(),
      const SearchView(),
      const FavoritesView(),
      const ProfileView(),
    ];

    return BlocBuilder<HomeScreenCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          body: IndexedStack(index: selectedIndex, children: _screens),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: Sizes.s8w,
                right: Sizes.s8w,
                top: Sizes.s6h,
                bottom: Sizes.s6h,
              ),
              child: GNav(
                padding: EdgeInsets.symmetric(
                  vertical: Sizes.s4h,
                  horizontal: Sizes.s8w,
                ),
                selectedIndex: selectedIndex,
                onTabChange: (idx) => context.read<HomeScreenCubit>().goTo(idx),
                rippleColor: context.colorScheme.onPrimary,
                hoverColor: context.colorScheme.onPrimary,
                haptic: true,
                tabBorderRadius: Sizes.s15r,
                curve: Curves.easeOutExpo,
                duration: const Duration(milliseconds: 500),
                gap: Sizes.s2w,
                color: context.colorScheme.onSurface,
                activeColor: context.colorScheme.tertiary,
                iconSize: Sizes.s25w,
                tabBackgroundColor: context.colorScheme.primary,
                tabs: [
                  GButton(icon: LineIcons.home, text: 'nav.home'.tr()),
                  GButton(icon: LineIcons.bars, text: 'nav.categories'.tr()),
                  GButton(icon: LineIcons.search, text: 'nav.search'.tr()),
                  GButton(icon: LineIcons.heart, text: 'nav.favorites'.tr()),
                  GButton(icon: LineIcons.user, text: 'nav.profile'.tr()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
