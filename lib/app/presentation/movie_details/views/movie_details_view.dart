import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qagile_task/core/theme/theme_controller.dart';
import '../../../../core/constants/theme_constants.dart';
import '../controllers/movie_details_controller.dart';
import '../../shared/widgets/genre_chip.dart';
import '../../shared/widgets/rating_stars.dart';
import '../../shared/widgets/shimmer_loading.dart';

class MovieDetailsView extends GetView<MovieDetailsController> {
   MovieDetailsView({Key? key}) : super(key: key);

  final RxBool isPlotExpanded = false.obs;

  Widget _buildLoadingState() {
    final themeController = Get.find<ThemeController>();
    final backgroundColor = themeController.isDarkMode 
        ? ThemeConstants.darkSurface 
        : ThemeConstants.lightBackground;
        
    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // SliverAppBar(
          //   expandedHeight: 400,
          //   pinned: true,
          //   flexibleSpace: FlexibleSpaceBar(
          //     background: ShimmerLoading(
          //       width: double.infinity,
          //       height: 400,
          //       borderRadius: 0,
          //     ),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(ThemeConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer
                  ShimmerLoading(
                    width: 200,
                    height: 32,
                  ),
                  const SizedBox(height: ThemeConstants.paddingSmall),
                  
                  // Year and runtime shimmer
                  Row(
                    children: [
                      ShimmerLoading(
                        width: 60,
                        height: 16,
                      ),
                      const SizedBox(width: ThemeConstants.paddingMedium),
                      ShimmerLoading(
                        width: 80,
                        height: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: ThemeConstants.paddingMedium),
                  
                  // Rating shimmer
                  ShimmerLoading(
                    width: 120,
                    height: 20,
                  ),
                  const SizedBox(height: ThemeConstants.paddingLarge),
                  
                  // Genres shimmer
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, __) => const SizedBox(
                        width: ThemeConstants.paddingSmall,
                      ),
                      itemBuilder: (_, __) => ShimmerLoading(
                        width: 80,
                        height: 32,
                        borderRadius: ThemeConstants.borderRadiusSmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.paddingLarge),
                  
                  // Action buttons shimmer
                  Row(
                    children: [
                      Expanded(
                        child: ShimmerLoading(
                          width: double.infinity,
                          height: 44,
                          borderRadius: ThemeConstants.borderRadiusMedium,
                        ),
                      ),
                      const SizedBox(width: ThemeConstants.paddingMedium),
                      ShimmerLoading(
                        width: 100,
                        height: 44,
                        borderRadius: ThemeConstants.borderRadiusMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: ThemeConstants.paddingLarge),
                  
                  // Plot shimmer
                  ShimmerLoading(
                    width: 100,
                    height: 24,
                  ),
                  const SizedBox(height: ThemeConstants.paddingMedium),
                  ShimmerLoading(
                    width: double.infinity,
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final backgroundColor = isDarkMode 
          ? ThemeConstants.darkSurface 
          : ThemeConstants.lightBackground;
      final textColor = isDarkMode 
          ? CupertinoColors.white 
          : ThemeConstants.lightText;

      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      if (controller.hasError.value) {
        return CupertinoPageScaffold(
          backgroundColor: backgroundColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_circle,
                  color: textColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load movie details',
                  style: ThemeConstants.lightBodyStyle.copyWith(
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  child: Text(
                    'Try Again',
                    style: TextStyle(color: textColor),
                  ),
                  onPressed: () => controller.loadMovieDetails(),
                ),
              ],
            ),
          ),
        );
      }

      return RepaintBoundary(
        key: controller.screenshotKey,
        child: CupertinoPageScaffold(
          backgroundColor: backgroundColor,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeader(isDarkMode, textColor, backgroundColor),
              _buildContent(isDarkMode, textColor, context),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader(bool isDarkMode, Color textColor, Color backgroundColor) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              controller.movieDetails.value.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: backgroundColor,
                child: Icon(
                  CupertinoIcons.film,
                  color: textColor,
                  size: 48,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor.withOpacity(0),
                    backgroundColor,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(CupertinoIcons.back, color: textColor),
        onPressed: () => Get.back(),
      ),
      actions: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.ellipsis, color: textColor),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildContent(bool isDarkMode, Color textColor, BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Basic Info
            Text(
              controller.movieDetails.value.title,
              style: ThemeConstants.lightTitleStyle.copyWith(
                fontSize: 28,
                color: textColor,
              ),
            ),
            const SizedBox(height: ThemeConstants.paddingSmall),
            
            // Year, Runtime, Rated
            Row(
              children: [
                Text(
                  controller.movieDetails.value.year,
                  style: ThemeConstants.lightBodyStyle.copyWith(color: textColor),
                ),
                const SizedBox(width: ThemeConstants.paddingMedium),
                Text(
                  controller.movieDetails.value.runtime,
                  style: ThemeConstants.lightBodyStyle.copyWith(color: textColor),
                ),
                const SizedBox(width: ThemeConstants.paddingMedium),
                Text(
                  controller.movieDetails.value.rated,
                  style: ThemeConstants.lightBodyStyle.copyWith(color: textColor),
                ),
              ],
            ),
            const SizedBox(height: ThemeConstants.paddingMedium),

            // Ratings
            _buildRatingsSection(textColor),
            const SizedBox(height: ThemeConstants.paddingLarge),

            // Genres
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.movieDetails.value.genres.length,
                separatorBuilder: (_, __) => const SizedBox(width: ThemeConstants.paddingSmall),
                itemBuilder: (context, index) {
                  final genre = controller.movieDetails.value.genres[index];
                  if (genre.isEmpty) return const SizedBox.shrink();
                  return GenreChip(label: genre);
                },
              ),
            ),
            const SizedBox(height: ThemeConstants.paddingLarge),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: CupertinoIcons.play_fill,
                    label: 'Watch now',
                    isPrimary: true,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(width: ThemeConstants.paddingMedium),
                _buildActionButton(
                  icon: CupertinoIcons.play_circle,
                  label: 'Trailer',
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
            const SizedBox(height: ThemeConstants.paddingLarge),
              // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionChip(
                  icon: Obx(() => Icon(
                    controller.isSaved.value 
                        ? CupertinoIcons.bookmark_fill
                        : CupertinoIcons.bookmark,
                    color: textColor,
                    size: 20,
                  )),
                  label: Obx(() => Text(
                    controller.isSaved.value ? 'Saved' : 'Save',
                    style: ThemeConstants.lightBodyStyle.copyWith(
                      color: textColor,
                    ),
                  )),
                  onTap: controller.toggleSave,
                  context: context,
                  isDarkMode: isDarkMode,
                ),
                _buildActionChip(
                  icon: Icon(
                    CupertinoIcons.share,
                    color: textColor,
                    size: 20,
                  ),
                  label: Text(
                    'Share',
                    style: ThemeConstants.lightBodyStyle.copyWith(
                      color: textColor,
                    ),
                  ),
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        title: const Text('Share Movie'),
                        actions: [
                          CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                              controller.shareScreenshot();
                            },
                            child: const Text('Share with Screenshot'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                              controller.shareMovie();
                            },
                            child: const Text('Share Details'),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () => Navigator.pop(context),
                          isDestructiveAction: true,
                          child: const Text('Cancel'),
                        ),
                      ),
                    );
                  },
                  context: context,
                  isDarkMode: isDarkMode,
                ),

                const SizedBox(height: ThemeConstants.paddingLarge),
                _buildActionChip(
                  icon: Icon(
                    CupertinoIcons.arrow_down_circle,
                    color: textColor,
                    size: 20,
                  ),
                  label: Obx(() => Text(
                    controller.isDownloading.value 
                        ? 'Downloading...'
                        : 'Download',
                    style: ThemeConstants.lightBodyStyle.copyWith(
                      color: textColor,
                    ),
                  )),
                  onTap: controller.startDownload,
                  context: context,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
            const SizedBox(height: ThemeConstants.paddingLarge),

            // Plot
            _buildInfoSection('Storyline', controller.movieDetails.value.plot, textColor, isDarkMode),
            const SizedBox(height: ThemeConstants.paddingLarge),

            // Cast & Crew
            _buildInfoSection('Director', controller.movieDetails.value.director, textColor, isDarkMode),
            const SizedBox(height: ThemeConstants.paddingMedium),
            _buildInfoSection('Writers', controller.movieDetails.value.writer, textColor, isDarkMode),
            const SizedBox(height: ThemeConstants.paddingMedium),
            _buildInfoSection('Actors', controller.movieDetails.value.actors, textColor, isDarkMode),
            const SizedBox(height: ThemeConstants.paddingLarge),

            // Additional Info
            _buildInfoSection('Language', controller.movieDetails.value.language, textColor, isDarkMode),
            const SizedBox(height: ThemeConstants.paddingMedium),
            _buildInfoSection('Country', controller.movieDetails.value.country, textColor, isDarkMode),
            const SizedBox(height: ThemeConstants.paddingMedium),
           

          
            
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, Color textColor, bool isDarkMode) {
    if (content.isEmpty) return const SizedBox.shrink();
    
    // Special handling for storyline/plot
    if (title == 'Storyline') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ThemeConstants.lightSubtitleStyle.copyWith(
              color: textColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.paddingSmall),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedCrossFade(
                  firstChild: Text(
                    content,
                    style: ThemeConstants.lightBodyStyle.copyWith(
                      color: textColor.withOpacity(0.8),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondChild: Text(
                    content,
                    style: ThemeConstants.lightBodyStyle.copyWith(
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                  crossFadeState: isPlotExpanded.value 
                      ? CrossFadeState.showSecond 
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 400),
                  firstCurve: Curves.easeOutCubic,
                  secondCurve: Curves.easeOutCubic,
                  sizeCurve: Curves.easeOutCubic,
                  alignment: Alignment.topLeft,
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          isPlotExpanded.value ? 'Show less' : 'Read more',
                          key: ValueKey<bool>(isPlotExpanded.value),
                          style: ThemeConstants.lightBodyStyle.copyWith(
                            color: isDarkMode 
                                ? CupertinoColors.activeBlue 
                                : ThemeConstants.primaryNavyBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isPlotExpanded.value ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: Icon(
                          CupertinoIcons.chevron_down,
                          color: isDarkMode
                              ? CupertinoColors.activeBlue 
                              : ThemeConstants.primaryNavyBlue,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => isPlotExpanded.toggle(),
                ),
              ],
            );
          }),
        ],
      );
    }

    // Regular section
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: ThemeConstants.lightSubtitleStyle.copyWith(
            color: textColor,
          ),
        ),
        const SizedBox(height: ThemeConstants.paddingSmall),
        Text(
          content,
          style: ThemeConstants.lightBodyStyle.copyWith(
            color: textColor.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingsSection(Color textColor) {
    final rating = controller.movieDetails.value.imdbRating;
    if (rating.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingStars(rating: rating),
        if (controller.movieDetails.value.ratings.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: controller.movieDetails.value.ratings
                .map((r) => Text(
                      '${r.source}: ${r.value}',
                      style: ThemeConstants.lightBodyStyle.copyWith(
                        color: textColor.withOpacity(0.7),
                      ),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool isPrimary = false,
    bool isDarkMode = true,
  }) {
    final borderColor = isPrimary 
        ? ThemeConstants.primaryNavyBlue 
        : (isDarkMode ? CupertinoColors.white : ThemeConstants.lightText);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.paddingMedium),
        decoration: BoxDecoration(
          color: isPrimary 
              ? ThemeConstants.primaryNavyBlue 
              : (isDarkMode ? ThemeConstants.darkSurface : ThemeConstants.lightBackground),
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? CupertinoColors.white : borderColor,
              size: 20,
            ),
            const SizedBox(width: ThemeConstants.paddingSmall),
            Text(
              label,
              style: ThemeConstants.lightBodyStyle.copyWith(
                color: isPrimary ? CupertinoColors.white : borderColor,
              ),
            ),
          ],
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _buildActionChip({
    required Widget icon,
    required Widget label,
    required VoidCallback onTap,
    required BuildContext context,
    bool isDarkMode = true,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.paddingMedium,
          vertical: ThemeConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: (isDarkMode 
              ? ThemeConstants.darkSurface 
              : ThemeConstants.lightSurface)
              .withOpacity(0.8),
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 8),
            label,
          ],
        ),
      ),
    );
  }
} 