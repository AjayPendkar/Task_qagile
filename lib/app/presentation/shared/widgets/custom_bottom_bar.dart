import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qagile_task/core/constants/theme_constants.dart';
import 'package:qagile_task/core/theme/theme_controller.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final iconColor = isDarkMode 
          ? CupertinoColors.white 
          : ThemeConstants.lightText;

      return ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: (isDarkMode 
                  ? ThemeConstants.darkSurface 
                  : ThemeConstants.lightBackground)
                  .withOpacity(0.8),
              border: Border(
                top: BorderSide(
                  color: (isDarkMode 
                      ? CupertinoColors.white 
                      : ThemeConstants.lightText)
                      .withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomBarItem(
                  icon: CupertinoIcons.home,
                  label: 'Home',
                  index: 0,
                  iconColor: iconColor,
                  isDarkMode: isDarkMode,
                ),
                _buildBottomBarItem(
                  icon: CupertinoIcons.film,
                  label: 'Trailer',
                  index: 1,
                  iconColor: iconColor,
                  isDarkMode: isDarkMode,
                ),
                _buildBottomBarItem(
                  icon: CupertinoIcons.bookmark,
                  label: 'Saved',
                  index: 2,
                  iconColor: iconColor,
                  isDarkMode: isDarkMode,
                ),
                _buildBottomBarItem(
                  icon: CupertinoIcons.arrow_down_circle,
                  label: 'Download',
                  index: 3,
                  iconColor: iconColor,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBottomBarItem({
    required IconData icon,
    required String label,
    required int index,
    required Color iconColor,
    required bool isDarkMode,
  }) {
    final isSelected = selectedIndex == index;
    final itemColor = isSelected 
        ? ThemeConstants.primaryNavyBlue 
        : iconColor;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: itemColor,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: ThemeConstants.lightBodyStyle.copyWith(
              color: itemColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
} 