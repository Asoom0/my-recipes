import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:my_recipes/controllers/favorites_controller/favorites_controller.dart';
import 'package:my_recipes/controllers/recipe_details_controller/recipe_details_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/core/strings/strings.dart';
import 'package:my_recipes/home/widgets/text_field_style.dart';
import 'package:my_recipes/utilities/pick_image.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';

class EditRecipeView extends StatelessWidget {
  final Map<String, dynamic> existingRecipe;
  const EditRecipeView({super.key, required this.existingRecipe});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipeDetailsCubit()..loadCategories(),
      child: EditRecipePage(existingRecipe: existingRecipe),
    );
  }
}

class EditRecipePage extends StatefulWidget {
  final Map<String, dynamic> existingRecipe;
  const EditRecipePage({super.key, required this.existingRecipe});

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  late TextEditingController recipeNameController;
  late TextEditingController ingredientsController;
  late TextEditingController instructionsController;
  String? selectedCategory;
  String? uploadedImageUrl;
  Uint8List? _imageData;

  bool get isEditing => true;

  @override
  void initState() {
    super.initState();
    recipeNameController = TextEditingController(
      text: widget.existingRecipe['recipeName'] ?? '',
    );
    selectedCategory = widget.existingRecipe['category'] ?? null;
    ingredientsController = TextEditingController(
      text: widget.existingRecipe['ingredients'] ?? '',
    );
    instructionsController = TextEditingController(
      text: widget.existingRecipe['instructions'] ?? '',
    );
    uploadedImageUrl = widget.existingRecipe['imageUrl'] ?? null;
  }

  @override
  void dispose() {
    recipeNameController.dispose();
    ingredientsController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      try {
        final bytes = await pickedImage.readAsBytes();
        final fileName = pickedImage.name;
        if (!mounted) return;
        setState(() {
          _imageData = bytes;
        });
        final imagePath = await uploadImageFromBytes(bytes, fileName);
        if (!mounted) return;
        setState(() {
          uploadedImageUrl = imagePath;
        });
      } catch (e) {
        print("Failed to upload image: $e");
      }
    }
  }

  void _submit() {
    context.read<RecipeDetailsCubit>().updateRecipe(
      id: widget.existingRecipe['id'],
      recipeName: recipeNameController.text.trim(),
      category: selectedCategory!.trim(),
      ingredients: ingredientsController.text.trim(),
      instructions: instructionsController.text.trim(),
      imageUrl: uploadedImageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('edit_recipe.app_bar'.tr())),
      body: SafeArea(
        child: BlocConsumer<RecipeDetailsCubit, RecipeDetailsState>(
          listener: (context, state) {
            if (state is RecipeDetailsLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Center(
                  child: CircularProgressIndicator(
                    color: context.colorScheme.primary,
                  ),
                ),
              );
            } else {
              if (Navigator.canPop(context)) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              if (state is RecipeDetailsUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      'edit_recipe.recipe_updated'.tr(),
                      style: TextStyle(color: context.colorScheme.tertiary),
                    ),
                  ),
                );
                final updatedRecipe = state.updatedRecipe;
                context.read<FavoritesCubit>().updateFavorite(updatedRecipe);
                Navigator.pop(context, updatedRecipe);
              } else if (state is RecipeDetailsFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      state.message,
                      style: TextStyle(color: context.colorScheme.tertiary),
                    ),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            List<Map<String, dynamic>> categories = [];
            if (state is RecipeDetailsCategoriesUpdated) {
              categories = state.categories;
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(Sizes.s20w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('categories.app_bar'.tr()),
                  SizedBox(height: Sizes.s8h),
                  if (categories.isNotEmpty)
                    Wrap(
                      spacing: Sizes.s10w,
                      runSpacing: Sizes.s10h,
                      children: categories.map((cat) {
                        final isSelected = selectedCategory == cat['name'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = cat['name'];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(Sizes.s8w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? context.colorScheme.secondary
                                  : context.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(Sizes.s12r),
                              border: Border.all(
                                color: context.colorScheme.secondary,
                                width: Sizes.s2w,
                              ),
                            ),
                            child: Image.asset(
                              cat['image'],
                              width: Sizes.s50w,
                              height: Sizes.s50h,
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Center(child: Text('recipes.no_categories'.tr())),
                  SizedBox(height: Sizes.s16h),

                  Text('add_recipe.name'.tr()),
                  SizedBox(height: Sizes.s8h),
                  TextFieldStyle(
                    controller: recipeNameController,
                    htext: 'add_recipe.name'.tr(),
                  ),

                  SizedBox(height: Sizes.s16h),
                  Text('add_recipe.ingredients'.tr()),
                  SizedBox(height: Sizes.s8h),
                  TextFieldStyle(
                    controller: ingredientsController,
                    htext: 'add_recipe.ingredients'.tr(),
                  ),

                  SizedBox(height: Sizes.s16h),
                  Text('add_recipe.instructions'.tr()),
                  SizedBox(height: Sizes.s8h),
                  TextFieldStyle(
                    controller: instructionsController,
                    htext: 'add_recipe.instructions'.tr(),
                  ),

                  SizedBox(height: Sizes.s16h),
                  Text('add_recipe.add_image'.tr()),
                  SizedBox(height: Sizes.s8h),
                  GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: DottedBorder(
                      color: context.colorScheme.primary,
                      strokeWidth: Sizes.s2w,
                      dashPattern: [Sizes.s6, Sizes.s4],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(Sizes.s12r),
                      child: Container(
                        width: double.infinity,
                        height: Sizes.s180h,
                        alignment: Alignment.center,
                        child: _imageData == null && uploadedImageUrl == null
                            ? Icon(
                                Icons.image,
                                size: Sizes.s40w,
                                color: context.colorScheme.primary,
                              )
                            : _imageData != null
                            ? Image.memory(
                                _imageData!,
                                width: double.infinity,
                                height: Sizes.s180h,
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                uploadedImageUrl!,
                                width: double.infinity,
                                height: Sizes.s180h,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      'edit_recipe.failed_to_load_image'.tr(),
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: Sizes.s24h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        foregroundColor: context.colorScheme.tertiary,
                        padding: EdgeInsets.zero, // أفضل إزالة padding عشان نتحكم بالحجم من الحجم الثابت
                        fixedSize: Size(Sizes.s250w, Sizes.s15h),
                      ),
                      onPressed: _submit,
                      child: Center(
                        child: Text(
                          'edit_recipe.edit_button'.tr(),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.tertiary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Sizes.s25h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
