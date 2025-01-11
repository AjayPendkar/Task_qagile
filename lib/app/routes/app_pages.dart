import 'package:flutter/cupertino.dart';
import '../presentation/home/views/home_view.dart';
import '../presentation/movie_details/views/movie_details_view.dart';

class AppPages {
  static const initial = Routes.home;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return CupertinoPageRoute(
          builder: (_) => const HomeView(),
        );
      case Routes.movieDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
          builder: (_) => MovieDetailsView(movieId: args['movieId']),
        );
      default:
        return CupertinoPageRoute(
          builder: (_) => const HomeView(),
        );
    }
  }
}

abstract class Routes {
  static const home = '/home';
  static const movieDetails = '/movie-details';
} 