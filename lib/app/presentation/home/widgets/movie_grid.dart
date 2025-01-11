import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qagile_task/core/theme/theme_controller.dart';
import '../controllers/home_controller.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../domain/entities/movie.dart';
import 'dart:ui';
import '../../../routes/app_pages.dart';
import '../../shared/widgets/shimmer_loading.dart';

class MovieGrid extends GetView<HomeController> {
  const MovieGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingGrid();
      }

      if (controller.isApiError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.exclamationmark_circle,
                size: 48,
                color: themeController.isDarkMode 
                    ? CupertinoColors.white 
                    : ThemeConstants.lightText,
              ),
              const SizedBox(height: 16),
              Text(
                controller.apiErrorMessage.value,
                style: ThemeConstants.lightBodyStyle.copyWith(
                  color: themeController.isDarkMode 
                      ? CupertinoColors.white 
                      : ThemeConstants.lightText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: controller.retryLastAction,
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
        );
      }

      if (controller.movies.isEmpty) {
        return Center(
          child: Text(
            'No movies found',
            style: ThemeConstants.lightBodyStyle.copyWith(
              color: themeController.isDarkMode 
                  ? CupertinoColors.white 
                  : ThemeConstants.lightText,
            ),
          ),
        );
      }

      return _buildGrid();
    });
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.movies.length,
        itemBuilder: (context, index) => _MovieCard(movie: controller.movies[index]),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => _buildShimmerCard(),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: ThemeConstants.getCardDecoration(false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ShimmerLoading(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 0,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      ThemeConstants.primaryBlack.withOpacity(0.9),
                      ThemeConstants.primaryBlack.withOpacity(0.6),
                      ThemeConstants.primaryBlack.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                padding: const EdgeInsets.all(ThemeConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(
                      width: 120,
                      height: 16,
                    ),
                    const SizedBox(height: ThemeConstants.paddingSmall),
                    ShimmerLoading(
                      width: 60,
                      height: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;

  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('🎬 Navigating to movie details: ${movie.imdbID}');
        Get.toNamed(
          AppPages.MOVIE_DETAILS,
          arguments: {'movieId': movie.imdbID},
        );
      },
      child: Container(
        decoration: ThemeConstants.getCardDecoration(false),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
          child: Stack(
            fit: StackFit.expand,
            children: [
              movie.posterPath.startsWith('http')
                  ? Image.network(
                      movie.posterPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildLoadingState();
                      },
                    )
                  : _buildPlaceholder(),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildMovieInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieInfo() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(ThemeConstants.borderRadiusLarge),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                ThemeConstants.primaryBlack.withOpacity(0.9),
                ThemeConstants.primaryBlack.withOpacity(0.6),
                ThemeConstants.primaryBlack.withOpacity(0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          padding: const EdgeInsets.all(ThemeConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: ThemeConstants.lightSubtitleStyle.copyWith(
                  color: CupertinoColors.white,
                ),
              ),
              const SizedBox(height: ThemeConstants.paddingSmall),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.paddingSmall,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: ThemeConstants.primaryNavyBlue.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusSmall),
                ),
                child: Text(
                  movie.year,
                  style: ThemeConstants.lightBodyStyle.copyWith(
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: ThemeConstants.lightSurface,
      child: const Center(
        child: Icon(
          CupertinoIcons.film,
          size: 40,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: ThemeConstants.lightSurface,
      child: const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
} 