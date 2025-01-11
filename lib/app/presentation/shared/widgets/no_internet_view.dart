import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qagile_task/core/constants/theme_constants.dart';
import 'package:qagile_task/core/theme/theme_controller.dart';

class NoInternetView extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetView({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final textColor = isDarkMode 
          ? CupertinoColors.white 
          : ThemeConstants.lightText;

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode 
                ? ThemeConstants.darkBackgroundGradient
                : ThemeConstants.lightBackgroundGradient,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.wifi_slash,
                  size: 64,
                  color: textColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'No Internet Connection',
                  style: ThemeConstants.lightTitleStyle.copyWith(
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Please check your internet connection and try again',
                  style: ThemeConstants.lightBodyStyle.copyWith(
                    color: textColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CupertinoButton.filled(
                  onPressed: onRetry,
                  borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        CupertinoIcons.refresh,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('Try Again'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
} 