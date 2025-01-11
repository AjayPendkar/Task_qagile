import 'package:flutter/cupertino.dart';
import '../../../domain/entities/movie.dart';
import '../../../../core/constants/theme_constants.dart';
import '../../movie_details/views/movie_details_view.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;

  const MovieGrid({
    Key? key,
    required this.movies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(ThemeConstants.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: ThemeConstants.paddingMedium,
        mainAxisSpacing: ThemeConstants.paddingMedium,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/movie-details',
              arguments: {'movieId': movie.imdbID},
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
            child: Image.network(
              movie.posterPath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: CupertinoColors.systemGrey5,
                child: const Icon(CupertinoIcons.photo),
              ),
            ),
          ),
        );
      },
    );
  }
} 