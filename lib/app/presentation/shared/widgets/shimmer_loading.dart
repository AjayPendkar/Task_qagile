import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:qagile_task/core/theme/theme_controller.dart';
import '../../../../core/constants/theme_constants.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Obx(() => Shimmer.fromColors(
      baseColor: themeController.isDarkMode
          ? Colors.grey[800]!
          : Colors.grey[300]!,
      highlightColor: themeController.isDarkMode
          ? Colors.grey[700]!
          : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: themeController.isDarkMode
              ? ThemeConstants.darkSurface
              : ThemeConstants.lightSurface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ));
  }
} 