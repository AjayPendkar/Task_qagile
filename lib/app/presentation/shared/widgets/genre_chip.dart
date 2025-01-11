import 'package:flutter/cupertino.dart';
import '../../../../core/constants/theme_constants.dart';

class GenreChip extends StatelessWidget {
  final String label;
  final bool isDarkMode;

  const GenreChip({
    Key? key,
    required this.label,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.paddingMedium,
        vertical: ThemeConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: (isDarkMode 
            ? ThemeConstants.darkSurface 
            : ThemeConstants.lightSurface)
            .withOpacity(0.8),
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusSmall),
      ),
      child: Text(
        label,
        style: ThemeConstants.lightBodyStyle.copyWith(
          color: isDarkMode 
              ? CupertinoColors.white 
              : ThemeConstants.lightText,
        ),
      ),
    );
  }
} 