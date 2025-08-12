import 'package:easy_localization/easy_localization.dart';
import 'package:my_recipes/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../../core/sizes/sizes.dart';

class RecipeCard extends StatefulWidget {
  final Map<String, dynamic> recipes;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onBookmarkPressed;

  const RecipeCard({
    super.key,
    required this.recipes,
    this.onTap,
    this.onBookmarkPressed,
    this.isFavorite = false,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    final String? imageUrl = widget.recipes['imageUrl'] as String?;
    final category = widget.recipes['category'] as String;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(Sizes.s6h),
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
              offset: Offset(Sizes.s0, Sizes.s4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(Sizes.s12r)),
              child: (imageUrl == null || imageUrl.isEmpty)
                  ? Image.asset(
                "assets/images/$category.png",
                height: Sizes.s120h,
                width: double.infinity,
                fit: BoxFit.fill,
              )
                  : Image.network(
                imageUrl,
                height: Sizes.s120h,
                width: double.infinity,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) {
                  return Image.asset(
                    "assets/images/$category.png",
                    height: Sizes.s120h,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Sizes.s8w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.recipes['recipeName'] ?? 'details.no_name'.tr(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: Sizes.s3h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: widget.onBookmarkPressed,
                          icon: Icon(
                            widget.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.isFavorite
                                ? context.colorScheme.primary
                                : context.colorScheme.onBackground,
                            size: Sizes.s22w,
                          ),
                          splashRadius: Sizes.s20r,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
