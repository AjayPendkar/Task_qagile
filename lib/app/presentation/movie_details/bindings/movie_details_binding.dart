import 'package:get/get.dart';
import '../controllers/movie_details_controller.dart';
import '../../../data/repositories/movie_repository.dart';

class MovieDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Make sure MovieRepository is available
    if (!Get.isRegistered<MovieRepository>()) {
      throw Exception('MovieRepository not found in GetX dependency injection');
    }

    // Print debug info
    print('🔍 MovieID from arguments: ${Get.arguments?['movieId']}');

    // Create controller with proper error handling
    try {
      final movieId = Get.arguments?['movieId'];
      if (movieId == null) throw Exception('Movie ID not provided');

      Get.lazyPut(() => MovieDetailsController(
        movieRepository: Get.find<MovieRepository>(),
        movieId: movieId,
      ));
    } catch (e) {
      print('❌ Error in MovieDetailsBinding: $e');
      rethrow;
    }
  }
} 