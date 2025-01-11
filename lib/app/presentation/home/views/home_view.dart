import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qagile_task/core/constants/theme_constants.dart';
import 'package:qagile_task/core/theme/theme_controller.dart';
import '../../shared/widgets/shimmer_loading.dart';
import '../controllers/home_controller.dart';
import '../widgets/movie_grid.dart';
import '../widgets/search_field.dart';
import '../../shared/widgets/no_internet_view.dart';
import '../../shared/widgets/custom_bottom_bar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final scrollController = ScrollController();

    // Add scroll listener
    scrollController.addListener(() {
      if (scrollController.offset > 0) {
        controller.isScrolled.value = true;
      } else {
        controller.isScrolled.value = false;
      }
    });
    
    return Obx(() {
      if (!controller.hasInternet.value) {
        return NoInternetView(
          onRetry: () => controller.loadInitialData(),
        );
      }

      return CupertinoPageScaffold(
        backgroundColor: themeController.isDarkMode 
            ? ThemeConstants.darkSurface 
            : ThemeConstants.lightBackground,
        navigationBar: _buildNavigationBar(themeController),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: themeController.isDarkMode 
                        ? ThemeConstants.darkBackgroundGradient
                        : ThemeConstants.lightBackgroundGradient,
                  ),
                ),
                child: SafeArea(
                  child: CustomScrollView(
                    controller: scrollController,  // Add scroll controller
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                     _buildSearchBar(context),
                      Obx(() => controller.isLoading.value
                          ? _buildCategoryChipsShimmer()
                          : _buildCategoryChips(context)),
                      _buildRecentSearches(context),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildForYouHeader(context),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: MovieGrid(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomBar(
                selectedIndex: controller.selectedTabIndex.value,
                onTap: controller.onTabSelected,
              ),
            ),
          ],
        ),
      );
    });
  }

  ObstructingPreferredSizeWidget _buildNavigationBar(ThemeController themeController) {
    return CupertinoNavigationBar(
      middle: Text(
        'Movies',
        style: themeController.isDarkMode 
            ? ThemeConstants.darkTitleStyle
            : ThemeConstants.lightTitleStyle,
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(
          themeController.isDarkMode 
              ? CupertinoIcons.sun_max 
              : CupertinoIcons.moon,
          color: themeController.isDarkMode 
              ? CupertinoColors.white 
              : ThemeConstants.primaryNavyBlue,
        ),
        onPressed: themeController.toggleTheme,
      ),
      backgroundColor: controller.isScrolled.value
          ? (themeController.isDarkMode 
              ? CupertinoColors.black 
              : CupertinoColors.white)
          : (themeController.isDarkMode 
              ? ThemeConstants.darkSurface 
              : ThemeConstants.lightBackground)
              .withOpacity(ThemeConstants.surfaceOpacity),
      border: null,
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.paddingLarge),
        child: Obx(() => Container(
          height: 44,
          decoration: ThemeConstants.getSearchBarDecoration(themeController.isDarkMode),
          child: const SearchField(),
        )),
      ),
    );
  }

  Widget _buildSearchBarShimmer() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.paddingLarge),
        child: ShimmerLoading(
          width: double.infinity,
          height: 44,
          borderRadius: ThemeConstants.borderRadiusMedium,
        ),
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            _buildChip(
              context,
              'Movies',
              controller.selectedCategory.value == 'movie',
              () => controller.onCategorySelected('movie'),
            ),
            const SizedBox(width: 8),
            _buildChip(
              context,
              'Series',
              controller.selectedCategory.value == 'series',
              () => controller.onCategorySelected('series'),
            ),
            const SizedBox(width: 8),
            _buildChip(
              context,
              'Episodes',
              controller.selectedCategory.value == 'episode',
              () => controller.onCategorySelected('episode'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    final themeController = Get.find<ThemeController>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.paddingLarge,
          vertical: ThemeConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? ThemeConstants.primaryNavyBlue
              : ThemeConstants.getThemedColor(
                  isDarkMode: themeController.isDarkMode,
                  lightColor: ThemeConstants.lightSurface,
                  darkColor: ThemeConstants.darkSurface,
                ),
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
          border: Border.all(
            color: isSelected 
                ? ThemeConstants.primaryNavyBlue
                : ThemeConstants.getThemedColor(
                    isDarkMode: themeController.isDarkMode,
                    lightColor: ThemeConstants.lightTextSecondary,
                    darkColor: ThemeConstants.darkTextSecondary,
                  ).withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: ThemeConstants.getThemedTextStyle(
            isDarkMode: themeController.isDarkMode,
            lightStyle: ThemeConstants.lightBodyStyle,
            darkStyle: ThemeConstants.darkBodyStyle,
          ).copyWith(
            color: isSelected 
                ? CupertinoColors.white 
                : ThemeConstants.getThemedColor(
                    isDarkMode: themeController.isDarkMode,
                    lightColor: ThemeConstants.lightText,
                    darkColor: ThemeConstants.darkText,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChipsShimmer() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            ShimmerLoading(
              width: 80,
              height: 32,
              borderRadius: ThemeConstants.borderRadiusMedium,
            ),
            const SizedBox(width: 8),
            ShimmerLoading(
              width: 80,
              height: 32,
              borderRadius: ThemeConstants.borderRadiusMedium,
            ),
            const SizedBox(width: 8),
            ShimmerLoading(
              width: 80,
              height: 32,
              borderRadius: ThemeConstants.borderRadiusMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() {
      if (controller.recentSearches.isEmpty) return const SliverToBoxAdapter();
      return SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'recent_search'.tr,
                    style: ThemeConstants.getThemedTextStyle(
                      isDarkMode: themeController.isDarkMode,
                      lightStyle: ThemeConstants.lightTitleStyle,
                      darkStyle: ThemeConstants.darkTitleStyle,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: controller.clearRecentSearches,
                    child: Text(
                      'remove'.tr,
                      style: TextStyle(
                        color: themeController.isDarkMode 
                            ? CupertinoColors.white 
                            : ThemeConstants.primaryNavyBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.recentSearches.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(20),
                      onPressed: () => controller.onRecentSearchTap(
                        controller.recentSearches[index],
                      ),
                      child: Text(
                        controller.recentSearches[index],
                        style: const TextStyle(
                          color: CupertinoColors.label,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildForYouHeader(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'for_you'.tr,
            style: ThemeConstants.getThemedTextStyle(
              isDarkMode: themeController.isDarkMode,
              lightStyle: ThemeConstants.lightTitleStyle,
              darkStyle: ThemeConstants.darkTitleStyle,
            ),
          ),
          Obx(() {
            if (!controller.isLoading.value && !controller.hasError.value) {
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: Text(
                  'see_all'.tr,
                  style: TextStyle(
                    color: themeController.isDarkMode 
                        ? CupertinoColors.white 
                        : ThemeConstants.primaryNavyBlue,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
} 
