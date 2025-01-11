import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qagile_task/app/data/repositories/movie_repository_impl.dart';
import '../bloc/movie_details_bloc.dart';
import '../../shared/widgets/genre_chip.dart';
import '../../shared/widgets/rating_stars.dart';
import '../../shared/widgets/shimmer_loading.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';

class MovieDetailsView extends StatelessWidget {
  final String movieId;
  final GlobalKey screenshotKey = GlobalKey();

  MovieDetailsView({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailsBloc(
        movieRepository: context.read<MovieRepositoryImpl>(),
      )..add(LoadMovieDetails(movieId)),
      child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return _buildLoadingState();
          }

          if (state is MovieDetailsLoaded) {
            return _buildContent(context, state);
          }

          if (state is MovieDetailsError) {
            return _buildErrorState(context, state.message);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return CupertinoPageScaffold(
      child: Center(
        child: ShimmerLoading(
          width: double.infinity,
          height: 300.0,
          isLoading: true,
          widget: Column(
            children: [
              Container(
                height: 300,
                color: CupertinoColors.systemGrey5,
              ),
              const SizedBox(height: 16),
              Container(
                height: 24,
                width: 200,
                color: CupertinoColors.systemGrey5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieDetailsLoaded state) {
    final details = state.details;
    final isDarkMode = context.read<ThemeBloc>().state.isDarkMode;
    final textColor = isDarkMode ? CupertinoColors.white : ThemeConstants.lightText;

    return RepaintBoundary(
      key: screenshotKey,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(details.title),
          backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ThemeConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster Image
              if (details.posterUrl.isNotEmpty)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
                    child: Image.network(
                      details.posterUrl,
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('🖼️ Image Error: $error');
                        return Container(
                          height: 400,
                          width: double.infinity,
                          color: CupertinoColors.systemGrey5,
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.photo,
                              size: 48,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 400,
                          width: double.infinity,
                          color: CupertinoColors.systemGrey6,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / 
                                    loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: ThemeConstants.paddingLarge),

              // Title and Year
              Text(
                details.title,
                style: ThemeConstants.lightHeadlineStyle.copyWith(
                  color: textColor,
                ),
              ),
              const SizedBox(height: ThemeConstants.paddingSmall),
              Text(
                '${details.year} • ${details.runtime}',
                style: ThemeConstants.lightBodyStyle.copyWith(
                  color: textColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: ThemeConstants.paddingMedium),

              // Ratings
              if (details.imdbRating.isNotEmpty) ...[
                RatingStars(rating: details.imdbRating),
                const SizedBox(height: ThemeConstants.paddingLarge),
              ],

              // Genres
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: details.genres.map((genre) => GenreChip(
                  label: genre,
                  isDarkMode: isDarkMode,
                )).toList(),
              ),
              const SizedBox(height: ThemeConstants.paddingLarge),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context: context,
                    icon: state.isSaved 
                        ? CupertinoIcons.bookmark_fill
                        : CupertinoIcons.bookmark,
                    label: state.isSaved ? 'Saved' : 'Save',
                    onTap: () => context.read<MovieDetailsBloc>().add(ToggleSave()),
                  ),
                  _buildActionButton(
                    context: context,
                    icon: CupertinoIcons.share,
                    label: 'Share',
                    onTap: () => context.read<MovieDetailsBloc>()
                        .add(ShareScreenshot(screenshotKey)),
                  ),
                  _buildActionButton(
                    context: context,
                    icon: state.isDownloading
                        ? CupertinoIcons.stop_fill
                        : CupertinoIcons.cloud_download,
                    label: state.isDownloading
                        ? '${(state.downloadProgress * 100).toInt()}%'
                        : 'Download',
                    onTap: () => context.read<MovieDetailsBloc>().add(StartDownload()),
                  ),
                ],
              ),
              const SizedBox(height: ThemeConstants.paddingLarge),

              // Plot
              Text(
                'Plot',
                style: ThemeConstants.lightSubtitleStyle.copyWith(
                  color: textColor,
                ),
              ),
              const SizedBox(height: ThemeConstants.paddingSmall),
              Text(
                details.plot,
                style: ThemeConstants.lightBodyStyle.copyWith(
                  color: textColor.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: ThemeConstants.paddingLarge),

              // Cast & Crew
              _buildInfoSection('Director', details.director, textColor),
              const SizedBox(height: ThemeConstants.paddingMedium),
              _buildInfoSection('Writers', details.writer, textColor),
              const SizedBox(height: ThemeConstants.paddingMedium),
              _buildInfoSection('Actors', details.actors, textColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, Color textColor) {
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

  Widget _buildErrorState(BuildContext context, String message) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            CupertinoButton(
              child: const Text('Retry'),
              onPressed: () {
                context.read<MovieDetailsBloc>().add(LoadMovieDetails(movieId));
              },
            ),
          ],
        ),
      ),
    );
  }
} 