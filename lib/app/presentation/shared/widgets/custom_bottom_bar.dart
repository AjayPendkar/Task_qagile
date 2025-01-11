import 'package:flutter/cupertino.dart';
import '../../../../core/constants/theme_constants.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final bool isDarkMode;

  const CustomBottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode 
            ? ThemeConstants.darkSurface 
            : ThemeConstants.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDarkMode 
                ? CupertinoColors.systemGrey6 
                : CupertinoColors.systemGrey4,
            width: 0.5,
          ),
        ),
      ),
      child: CupertinoTabBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bookmark),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
} 