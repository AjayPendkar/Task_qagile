import 'package:flutter/cupertino.dart';

class ThemeConstants {
  // Base Colors
  static const Color primaryBlack = Color(0xFF000000);
  static const Color primaryNavyBlue = Color(0xFF001845);
  static const Color secondaryNavyBlue = Color(0xFF000C24);
  
  // Light Theme Colors
  static const Color lightBackground = CupertinoColors.white;
  static const Color lightText = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color lightSurface = Color(0xFFF5F5F5);
  
  // Dark Theme Colors
  static const Color darkText = CupertinoColors.white;
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkSurface = Color(0xFF1A1A1A);
  
  // Gradient Colors
  static const List<Color> lightBackgroundGradient = [
    CupertinoColors.white,
    Color(0xFFE8F1FF),
    Color(0xFFF0F4FF),
  ];
  
  static const List<Color> darkBackgroundGradient = [
    primaryBlack,
    secondaryNavyBlue,
    primaryNavyBlue,
  ];
  
  // UI Colors
  static const Color accentBlue = Color(0xFF2E5CFF);
  static const Color errorRed = Color(0xFFFF3B30);
  static const Color successGreen = Color(0xFF34C759);
  
  // Opacity Values
  static const double activeOpacity = 1.0;
  static const double inactiveOpacity = 0.3;
  static const double surfaceOpacity = 0.7;
  
  // Border Radius
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusSmall = 8.0;
  
  // Padding & Spacing
  static const double paddingLarge = 16.0;
  static const double paddingMedium = 12.0;
  static const double paddingSmall = 8.0;
  
  // Font Sizes
  static const double fontSizeLarge = 20.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeSmall = 14.0;
  static const double fontSizeXSmall = 12.0;
  
  // Text Styles - Light Theme
  static TextStyle lightTitleStyle = TextStyle(
    color: lightText,
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.w600,
  );
  
  static TextStyle lightSubtitleStyle = TextStyle(
    color: lightText,
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w500,
  );
  
  static TextStyle lightBodyStyle = TextStyle(
    color: lightTextSecondary,
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.normal,
  );
  
  // Text Styles - Dark Theme
  static TextStyle darkTitleStyle = TextStyle(
    color: darkText,
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.w600,
  );
  
  static TextStyle darkSubtitleStyle = TextStyle(
    color: darkText,
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w500,
  );
  
  static TextStyle darkBodyStyle = TextStyle(
    color: darkTextSecondary,
    fontSize: fontSizeSmall,
    fontWeight: FontWeight.normal,
  );
  
  // Helper method to get theme-aware styles
  static TextStyle getThemedTextStyle({
    required bool isDarkMode,
    required TextStyle lightStyle,
    required TextStyle darkStyle,
  }) {
    return isDarkMode ? darkStyle : lightStyle;
  }
  
  // Helper method to get theme-aware colors
  static Color getThemedColor({
    required bool isDarkMode,
    required Color lightColor,
    required Color darkColor,
  }) {
    return isDarkMode ? darkColor : lightColor;
  }
  
  // Search Bar Theme
  static BoxDecoration getSearchBarDecoration(bool isDarkMode) {
    return BoxDecoration(
      color: isDarkMode ? darkSurface : lightSurface,
      borderRadius: BorderRadius.circular(borderRadiusMedium),
      border: Border.all(
        color: isDarkMode ? darkTextSecondary.withOpacity(0.1) : lightTextSecondary.withOpacity(0.1),
      ),
    );
  }
  
  // Card Theme
  static BoxDecoration getCardDecoration(bool isDarkMode) {
    return BoxDecoration(
      color: isDarkMode ? darkSurface : lightSurface,
      borderRadius: BorderRadius.circular(borderRadiusLarge),
      boxShadow: [
        BoxShadow(
          color: (isDarkMode ? darkText : lightText).withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
  
  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primaryNavyBlue,
    scaffoldBackgroundColor: lightBackground,
    barBackgroundColor: lightBackground.withOpacity(surfaceOpacity),
    textTheme: CupertinoTextThemeData(
      primaryColor: primaryNavyBlue,
      textStyle: lightBodyStyle,
      actionTextStyle: lightSubtitleStyle,
      navTitleTextStyle: lightTitleStyle,
      navLargeTitleTextStyle: lightTitleStyle.copyWith(
        fontSize: fontSizeLarge * 1.4,
        fontWeight: FontWeight.bold,
      ),
      navActionTextStyle: lightSubtitleStyle,
      tabLabelTextStyle: lightBodyStyle,
      dateTimePickerTextStyle: lightBodyStyle,
    ),
  );
} 