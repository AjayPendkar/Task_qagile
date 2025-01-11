import '../providers/api_client.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';

class MovieRepository {
  final ApiClient apiClient;

  MovieRepository({required this.apiClient});

  Future<List<Movie>> searchMovies({
    required String query,
    String? year,
    String type = 'movie',
    int page = 1,
  }) async {
    try {
      final response = await apiClient.searchMovies(
        query: query,
        year: year,
        type: type,
        page: page,
      );

      if (response['Response'] == 'True') {
        final movies = (response['Search'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();
        return movies;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  Future<MovieDetails> getMovieDetails(String movieId) async {
    try {
      final response = await apiClient.getMovieDetails(movieId);

      if (response['Response'] == 'True') {
        return MovieDetails.fromJson(response);
      }
      throw Exception(response['Error'] ?? 'Failed to get movie details');
    } catch (e) {
      throw Exception('Failed to get movie details: $e');
    }
  }
} 