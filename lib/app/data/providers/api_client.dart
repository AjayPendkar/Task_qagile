import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  final String baseUrl = 'https://www.omdbapi.com';
  final String apiKey = 'b5b01745';

  Future<Map<String, dynamic>> searchMovies({
    required String query,
    String? year,
    int page = 1,
    String type = 'movie',
  }) async {
    try {
      final Map<String, String> params = {
        'apikey': apiKey,
        's': query.isEmpty ? 'Batman' : query,
        'type': type,
        'page': page.toString(),
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: params);
      print('🎯 API Request URL: $uri');

      final response = await http.get(uri);
      print('📊 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📥 Parsed Response: $data');
        return data;
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Exception: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMovieDetails(String movieId) async {
    try {
      final params = {
        'apikey': apiKey,
        'i': movieId,
        'plot': 'full',
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: params);
      print('🎯 Details Request URL: $uri');

      final response = await http.get(uri);
      print('📊 Details Status: ${response.statusCode}');
      print('📦 Details Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get movie details');
      }
    } catch (e) {
      print('❌ Details Exception: $e');
      rethrow;
    }
  }
} 