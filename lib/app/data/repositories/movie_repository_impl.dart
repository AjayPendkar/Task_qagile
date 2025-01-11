import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_repository.dart';
import '../providers/api_client.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ApiClient apiClient;

  MovieRepositoryImpl({required this.apiClient});

  @override
  Future<List<Movie>> searchMovies({
    required String query,
    required String type,
  }) async {
    try {
      print('🎬 Repository searching for: $query');
      final response = await apiClient.searchMovies(
        query: query,
        type: type,
      );

      print('📦 Raw API Response: $response');

      if (response['Response'] == 'True' && response['Search'] != null) {
        final List<dynamic> results = response['Search'];
        final movies = results.map((json) => Movie.fromJson(json)).toList();
        print('📽 Parsed ${movies.length} movies');
        return movies;
      } else {
        print('⚠️ No results: ${response['Error'] ?? 'Unknown error'}');
        return [];
      }
    } catch (e) {
      print('💥 Repository error: $e');
      throw Exception('Search failed: $e');
    }
  }

  @override
  Future<MovieDetails> getMovieDetails(String movieId) async {
    try {
      final response = await apiClient.getMovieDetails(movieId);

      if (response['Response'] == 'True') {
        return MovieDetails.fromJson(response);
      } else {
        throw Exception(response['Error'] ?? 'Failed to get movie details');
      }
    } catch (e) {
      throw Exception('Failed to get movie details: $e');
    }
  }
} 