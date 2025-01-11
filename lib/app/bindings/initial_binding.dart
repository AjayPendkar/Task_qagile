import 'package:get/get.dart';
import '../data/providers/api_client.dart';
import '../data/repositories/movie_repository.dart';
import '../presentation/home/controllers/home_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // API Client
    Get.put(ApiClient());

    // Repository
    Get.put(MovieRepository(apiClient: Get.find()));

    // Controllers
    Get.put(HomeController(movieRepository: Get.find()));
  }
} 