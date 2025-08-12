import 'dart:typed_data';
import 'package:my_recipes/controllers/recipes_controller/recipes_controller.dart';
import 'package:my_recipes/controllers/add_recipe_controller/add_recipe_controller.dart';
import 'package:my_recipes/core/sizes/sizes.dart';
import 'package:my_recipes/home/widgets/text_field_style.dart';
import 'package:my_recipes/utilities/pick_image.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:my_recipes/view/recipes_view/recipes_view.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class AddRecipeView extends StatelessWidget {
  const AddRecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddRecipeCubit()..loadCategories(),
      child: const AddRecipePage(),
    );
  }
}

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final recipeNameController = TextEditingController();
  String? selectedCategory;
  final ingredientsController = TextEditingController();
  final instructionsController = TextEditingController();
  String? uploadedImageUrl;
  Uint8List? _imageData;

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

  void _addRecipe() {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("shared.select_category".tr())),
      );
      return;
    }

    context.read<AddRecipeCubit>().addRecipe(
      recipeNameController.text.trim(),
      selectedCategory!.trim(),
      ingredientsController.text.trim(),
      instructionsController.text.trim(),
      uploadedImageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("add_recipe.app_bar".tr())),
      body: SafeArea(
        child: BlocConsumer<AddRecipeCubit, AddRecipeState>(
          listener: (context, state) {
            if (state is AddRecipeLoading) {
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

              if (state is AddRecipeSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      "add_recipe.added_success".tr(),
                      style: TextStyle(color: context.colorScheme.tertiary),
                    ),
                  ),
                );

                final selectedCategoryName = selectedCategory!.trim();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => RecipeCubit()
                        ..fetchRecipesByCategory(selectedCategoryName),
                      child: RecipesView(categoryName: selectedCategoryName),
                    ),
                  ),
                );
              } else if (state is AddRecipeFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      state.errorMessage,
                      style: TextStyle(color: context.colorScheme.tertiary),
                    ),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            List<Map<String, dynamic>> categories = [];
            if (state is AddRecipeCategoriesUpdated) {
              categories = state.categories;
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(Sizes.s20w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("categories.app_bar".tr()),
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
                    Center(child: Text("home.no_categories".tr())),
                  SizedBox(height: Sizes.s16h),

                  Text("add_recipe.name".tr()),
                  SizedBox(height: Sizes.s8h),
                  TextFieldStyle(
                    controller: recipeNameController,
                    htext: "add_recipe.name".tr(),
                  ),

                  SizedBox(height: Sizes.s16h),
                  Text("add_recipe.ingredients".tr()),
                  SizedBox(height: Sizes.s8h),
                  TextFieldStyle(
                    controller: ingredientsController,
                    htext: "add_recipe.ingredients".tr(),
                  ),

                  SizedBox(height: Sizes.s16h),
                  Text("add_recipe.instructions".tr()),
                  SizedBox(height: Sizes.s8h),
                  TextFieldStyle(
                    controller: instructionsController,
                    htext: "add_recipe.instructions".tr(),
                  ),

                  SizedBox(height: Sizes.s16h),
                  Text("add_recipe.add_image".tr()),
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
                        child: _imageData == null
                            ? Icon(
                          Icons.image,
                          size: Sizes.s40w,
                          color: context.colorScheme.primary,
                        )
                            : Image.memory(
                          _imageData!,
                          width: double.infinity,
                          height: Sizes.s180h,
                          fit: BoxFit.fill,
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
                      onPressed: _addRecipe,
                      child: Center(
                        child: Text(
                          "add_recipe.add_button".tr(),
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
