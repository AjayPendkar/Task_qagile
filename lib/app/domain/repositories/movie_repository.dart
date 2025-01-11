import '../entities/movie.dart';
import '../entities/movie_details.dart';

abstract class MovieRepository {
  Future<List<Movie>> searchMovies({
    required String query,
    required String type,
  });

  Future<MovieDetails> getMovieDetails(String movieId);
} 