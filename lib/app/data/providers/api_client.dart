import 'package:get/get.dart';
import '../../../core/config/env_config.dart';

class ApiClient extends GetConnect {
  Future<Response> searchMovies({
    required String query,
    String? year,
    int page = 1,
    String type = 'movie',
  }) async {
    final queryParams = {
      'apikey': EnvConfig.apiKey,
      's': query.isEmpty ? 'movie' : query,
      'type': type,
      'y': year,
      'page': page.toString(),
    };

    print('🌐 API Call (Search): ${EnvConfig.apiBaseUrl}');
    print('📝 Params: $queryParams');

    final response = await get(EnvConfig.apiBaseUrl, query: queryParams);
    
    print('📥 Response: ${response.body}');
    return response;
  }

  Future<Response> getMovieDetails(String movieId) async {
    final queryParams = {
      'apikey': EnvConfig.apiKey,
      'i': movieId,
      'plot': 'full',
    };

    print('🌐 API Call (Details): ${EnvConfig.apiBaseUrl}');
    print('📝 Params: $queryParams');

    final response = await get(EnvConfig.apiBaseUrl, query: queryParams);
    
    print('📥 Response: ${response.body}');
    return response;
  }
} 