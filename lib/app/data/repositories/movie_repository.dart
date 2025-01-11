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
      print('🔍 Searching movies: $query');
      final response = await apiClient.searchMovies(
        query: query,
        year: year,
        type: type,
        page: page,
      );

      if (response.status.hasError) {
        print('❌ Search Error: ${response.statusText}');
        return [];
      }

      final data = response.body;
      if (data['Response'] == 'True') {
        final movies = (data['Search'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();
        print('✅ Found ${movies.length} movies');
        return movies;
      }
      print('⚠️ No movies found');
      return [];
    } catch (e) {
      print('❌ Search Exception: $e');
      return [];
    }
  }

  Future<MovieDetails> getMovieDetails(String movieId) async {
    try {
      print('🔍 Getting movie details: $movieId');
      final response = await apiClient.getMovieDetails(movieId);
      
      if (response.status.hasError) {
        print('❌ Details Error: ${response.statusText}');
        throw Exception('Failed to load movie details');
      }

      final details = MovieDetails.fromJson(response.body);
      print('✅ Got details for: ${details.title}');
      return details;
    } catch (e) {
      print('❌ Details Exception: $e');
      throw Exception('Failed to load movie details');
    }
  }
} 