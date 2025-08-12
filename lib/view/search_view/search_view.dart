import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_recipes/controllers/search_controller/search_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
//import 'package:my_recipes/core/strings/strings.dart';
import 'package:my_recipes/view/recipe_details/recipe_details_view.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> searchHistory = [];
  String currentQuery = "";

  @override
  void initState() {
    super.initState();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      currentQuery = query;
    });

    context.read<SearchCubit>().searchRecipes(query);

    if (!searchHistory.contains(query)) {
      setState(() {
        searchHistory.insert(0, query);
        if (searchHistory.length > 10) searchHistory.removeLast();
      });
    }
  }

  void _clearSearchHistory() {
    setState(() {
      searchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('search.app_bar'.tr()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Sizes.s12w),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _performSearch(),
                      onChanged: (value) {
                        if (value.trim().isEmpty) {
                          setState(() {
                            currentQuery = '';
                          });
                          context.read<SearchCubit>().clearSearchResults();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'search.hint'.tr(),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.s12r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Sizes.s8w),
                  ElevatedButton(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.s12r),
                        side: BorderSide(
                          color: context.colorScheme.onPrimary,
                          width: Sizes.sZeroAndHalf,
                        ),
                      ),
                      minimumSize: Size(55.w, 55.h),
                      maximumSize: Size(55.w, 55.h),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(
                      Icons.search,
                      color: context.colorScheme.onPrimary,
                      size: Sizes.s26w,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: currentQuery.trim().isEmpty
                  ? _buildSearchHistory()
                  : BlocBuilder<SearchCubit, SearchState>(
                builder: (_, state) {
                  if (state is SearchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchFailure) {
                    return Center(child: Text(state.errorMessage));
                  } else if (state is SearchSuccess) {
                    if (state.recipes.isEmpty) {
                      return Center(child: Text('search.no_result'.tr()));
                    }
                    return ListView.builder(
                      itemCount: state.recipes.length,
                      itemBuilder: (_, index) {
                        final recipe = state.recipes[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: Sizes.s12w,
                            vertical: Sizes.s8h,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Sizes.s12r,
                            ),
                            child: (recipe['imageUrl'] == null ||
                                recipe['imageUrl'].toString().isEmpty)
                                ? Image.asset(
                              "assets/images/${recipe['category']}.png",
                              width: Sizes.s65w,
                              height: Sizes.s65h,
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                              recipe['imageUrl'],
                              width: Sizes.s65w,
                              height: Sizes.s65h,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return Image.asset(
                                  "assets/images/${recipe['category']}.png",
                                  width: Sizes.s65w,
                                  height: Sizes.s65h,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          title: Text(
                            recipe['recipeName'] ?? "search.no_name".tr(),
                            style: context.textTheme.bodyLarge,
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    RecipeDetails(data: recipe),
                              ),
                            );
                            if (result == 'deleted') {
                              context.read<SearchCubit>().searchRecipes(
                                currentQuery,
                              );
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    if (searchHistory.isEmpty) {
      return Center(child: Text('search.no_history'.tr()));
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.s16w,
            vertical: Sizes.s8h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('search.history'.tr(), style: context.textTheme.bodyMedium),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: _clearSearchHistory,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchHistory.length,
            itemBuilder: (context, index) {
              final term = searchHistory[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(term),
                onTap: () {
                  _searchController.text = term;
                  _performSearch();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
