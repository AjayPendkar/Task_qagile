import 'package:flutter/cupertino.dart';
import '../../../../core/constants/theme_constants.dart';

class SearchField extends StatelessWidget {
  final Function(String) onChanged;

  const SearchField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      placeholder: 'Search movies, series...',
      onChanged: onChanged,
      style: ThemeConstants.lightBodyStyle,
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.paddingMedium,
        vertical: ThemeConstants.paddingSmall,
      ),
    );
  }
} 