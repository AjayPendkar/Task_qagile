import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/theme_constants.dart';
import '../controllers/home_controller.dart';
import 'package:qagile_task/core/theme/theme_controller.dart';

class SearchField extends GetView<HomeController> {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Obx(() => CupertinoTextField(
      controller: controller.searchController,
      focusNode: controller.searchFocusNode,
      onChanged: controller.onSearchQueryChanged,
      autofocus: false,
      enableSuggestions: true,
      textInputAction: TextInputAction.search,
      onSubmitted: (query) => controller.onSearchQueryChanged(query),
      placeholder: 'search'.tr,
      cursorColor: themeController.isDarkMode 
          ? CupertinoColors.white
          : ThemeConstants.primaryNavyBlue,
      placeholderStyle: ThemeConstants.getThemedTextStyle(
        isDarkMode: themeController.isDarkMode,
        lightStyle: ThemeConstants.lightBodyStyle.copyWith(
          color: ThemeConstants.lightTextSecondary,
        ),
        darkStyle: ThemeConstants.darkBodyStyle,
      ),
      style: ThemeConstants.getThemedTextStyle(
        isDarkMode: themeController.isDarkMode,
        lightStyle: ThemeConstants.lightSubtitleStyle.copyWith(
          color: ThemeConstants.lightText,
        ),
        darkStyle: ThemeConstants.darkSubtitleStyle,
      ),
      prefix: Padding(
        padding: const EdgeInsets.only(left: ThemeConstants.paddingMedium),
        child: Icon(
          CupertinoIcons.search,
          color: ThemeConstants.getThemedColor(
            isDarkMode: themeController.isDarkMode,
            lightColor: ThemeConstants.lightTextSecondary,
            darkColor: ThemeConstants.darkTextSecondary,
          ),
          size: 20,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: controller.searchFocusNode.hasFocus
              ? (themeController.isDarkMode
                  ? CupertinoColors.white
                  : ThemeConstants.primaryNavyBlue)
              : Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      ),
    ));
  }
} 