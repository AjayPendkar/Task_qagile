import 'package:get/get.dart';
import '../bindings/initial_binding.dart';
import '../presentation/home/views/home_view.dart';
import '../presentation/splash/views/splash_view.dart';
import '../presentation/splash/controllers/splash_controller.dart';
import '../presentation/movie_details/bindings/movie_details_binding.dart';
import '../presentation/movie_details/views/movie_details_view.dart';

class AppPages {
  static const INITIAL = '/home';
  static const MOVIE_DETAILS = '/movie-details';
  
  static final routes = [
    GetPage(
      name: '/splash',
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: '/home',
      page: () => const HomeView(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: MOVIE_DETAILS,
      page: () =>  MovieDetailsView(),
      binding: MovieDetailsBinding(),
    ),
  ];
} 