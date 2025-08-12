import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipes/controllers/favorites_controller/favorites_controller.dart';
import 'package:my_recipes/controllers/recipe_details_controller/recipe_details_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
//import 'package:my_recipes/core/strings/strings.dart';
import 'package:my_recipes/home/widgets/icon_design.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:my_recipes/view/edit_recipe/edit_recipe_view.dart';
import 'package:easy_localization/easy_localization.dart';

class RecipeDetails extends StatelessWidget {
  final Map<String, dynamic> data;
  const RecipeDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipeDetailsCubit(),
      child: RecipeDetailsView(data),
    );
  }
}

class RecipeDetailsView extends StatefulWidget {
  const RecipeDetailsView(this.data, {super.key});
  final Map<String, dynamic> data;

  @override
  State<RecipeDetailsView> createState() => _RecipeDetailsViewState();
}

class _RecipeDetailsViewState extends State<RecipeDetailsView> {
  @override
  Widget build(BuildContext context) {
    final String? imgUrl = widget.data['imageUrl'] as String?;
    final String fallback = "assets/images/${widget.data['category']}.png";

    return BlocListener<RecipeDetailsCubit, RecipeDetailsState>(
      listener: (context, state) {
        if (state is RecipeDetailsSuccess) {
          context.read<FavoritesCubit>().removeFavorite(widget.data);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('details.deleted_success'.tr()),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, 'deleted');
        } else if (state is RecipeDetailsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('details.app_bar'.tr()),
          ),
          actions: [
            IconButton(
              icon: IconDesign(
                icon: Icons.edit,
                backgroundColor: context.colorScheme.primaryContainer,
                borderColor: context.colorScheme.primaryContainer,
                iconColor: context.colorScheme.primary,
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditRecipeView(existingRecipe: widget.data),
                  ),
                );
                if (result is Map<String, dynamic>) {
                  setState(() {
                    widget.data.clear();
                    widget.data.addAll(result);
                  });
                }
              },
            ),
            IconButton(
              icon: IconDesign(
                icon: Icons.delete,
                backgroundColor: context.colorScheme.primaryContainer,
                borderColor: context.colorScheme.primaryContainer,
                iconColor: context.colorScheme.primary,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text('details.delete'.tr()),
                    content: Text('details.delete_confirm'.tr()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          'shared.cancel'.tr(),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext,'deleted');
                          context.read<RecipeDetailsCubit>().deleteRecipe(
                            widget.data['id'],
                          );
                        },
                        child: Text(
                          'details.delete_button'.tr(),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Sizes.s20w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(Sizes.s6w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(Sizes.s12r),
                      border: Border.all(
                        color: context.colorScheme.primary,
                        width: Sizes.s1AndHalfw,
                      ),
                    ),
                    child: Text(
                      "${widget.data['recipeName']}",
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: Sizes.s20h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.s16r),
                    child: Container(
                      padding: EdgeInsets.all(Sizes.s6w),
                      width: double.infinity,
                      height: Sizes.s300h,
                      decoration: BoxDecoration(
                        color: context.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(Sizes.s16r),
                        border: Border.all(
                          color: context.colorScheme.primary,
                          width: Sizes.s1AndHalfw,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Sizes.s14r),
                        child: Builder(
                          builder: (_) {
                            if (imgUrl != null &&
                                imgUrl.isNotEmpty &&
                                (imgUrl.startsWith('http://') ||
                                    imgUrl.startsWith('https://'))) {
                              return Image.network(
                                imgUrl,
                                fit: BoxFit.fill,
                                loadingBuilder: (_, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : Center(
                                  child: CircularProgressIndicator(
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                                errorBuilder: (_, __, ___) =>
                                    Image.asset(fallback, fit: BoxFit.fill),
                              );
                            } else {
                              return Image.asset(fallback, fit: BoxFit.fill);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Sizes.s30h),
                  Text('details.ingredients'.tr(), style: context.textTheme.bodyMedium),
                  SizedBox(height: Sizes.s6h),
                  Container(
                    padding: EdgeInsets.all(Sizes.s6w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(Sizes.s12r),
                      border: Border.all(
                        color: context.colorScheme.primary,
                        width: Sizes.s1AndHalfw,
                      ),
                    ),
                    child: Text(
                      "${widget.data['ingredients']}",
                      style: context.textTheme.headlineSmall,
                    ),
                  ),
                  SizedBox(height: Sizes.s30h),
                  Text('details.instructions'.tr(), style: context.textTheme.bodyMedium),
                  SizedBox(height: Sizes.s6h),
                  Container(
                    padding: EdgeInsets.all(Sizes.s6w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(Sizes.s12r),
                      border: Border.all(
                        color: context.colorScheme.primary,
                        width: Sizes.s1AndHalfw,
                      ),
                    ),
                    child: Text(
                      "${widget.data['instructions']}",
                      style: context.textTheme.headlineSmall,
                    ),
                  ),
                  SizedBox(height: Sizes.s25h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
