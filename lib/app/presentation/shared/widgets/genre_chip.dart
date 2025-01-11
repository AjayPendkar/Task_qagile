import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qagile_task/core/constants/theme_constants.dart';
import 'package:qagile_task/core/theme/theme_controller.dart';

class GenreChip extends StatelessWidget {
  final String label;

  const GenreChip({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final backgroundColor = isDarkMode
          ? ThemeConstants.darkSurface.withOpacity(0.7)
          : ThemeConstants.lightSurface;
      final borderColor = isDarkMode
          ? CupertinoColors.white.withOpacity(0.2)
          : ThemeConstants.lightTextSecondary.withOpacity(0.2);
      final textColor = isDarkMode
          ? CupertinoColors.white
          : ThemeConstants.lightText;

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.paddingMedium,
          vertical: ThemeConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusSmall),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: ThemeConstants.lightBodyStyle.copyWith(
            color: textColor,
          ),
        ),
      );
    });
  }
} 