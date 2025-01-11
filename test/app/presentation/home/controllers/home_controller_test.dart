import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:qagile_task/app/data/repositories/movie_repository.dart';
import 'package:qagile_task/app/domain/entities/movie.dart';
import 'package:qagile_task/app/presentation/home/controllers/home_controller.dart';

@GenerateNiceMocks([
  MockSpec<MovieRepository>(),
  MockSpec<Connectivity>(),
])
import 'home_controller_test.mocks.dart';

void main() {
  late HomeController controller;
  late MockMovieRepository mockRepository;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockRepository = MockMovieRepository();
    mockConnectivity = MockConnectivity();
    
    // Mock connectivity check
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.wifi);
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => Stream.value(ConnectivityResult.wifi));

    controller = HomeController(
      movieRepository: mockRepository,
      connectivity: mockConnectivity, // Pass mocked connectivity
    );
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeController Tests', () {
    test('initial values should be correct', () {
      expect(controller.isLoading.value, false);
      expect(controller.hasError.value, false);
      expect(controller.movies.isEmpty, true);
      expect(controller.selectedCategory.value, 'movie');
      expect(controller.recentSearches.isEmpty, true);
      expect(controller.hasInternet.value, true);
    });

    test('loadInitialData success should update movies', () async {
      final mockMovies = [
        Movie(
          title: 'Test Movie',
          year: '2024',
          imdbID: 'test123',
          type: 'movie',
          posterPath: 'test.jpg',
        ),
      ];

      when(mockRepository.searchMovies(
        query: 'movie',
        type: 'movie',
      )).thenAnswer((_) async => mockMovies);

      await controller.loadInitialData();

      expect(controller.isLoading.value, false);
      expect(controller.hasError.value, false);
      expect(controller.movies, mockMovies);
    });

    test('search should update recent searches', () async {
      final mockMovies = [
        Movie(
          title: 'Batman',
          year: '2022',
          imdbID: 'tt123',
          type: 'movie',
          posterPath: 'batman.jpg',
        ),
      ];

      when(mockRepository.searchMovies(
        query: 'Batman',
        type: 'movie',
      )).thenAnswer((_) async => mockMovies);

      controller.searchController.text = 'Batman';
      controller.onSearchQueryChanged('Batman');
      
      // Wait for debounce
      await Future.delayed(const Duration(milliseconds: 500));

      expect(controller.recentSearches.contains('Batman'), true);
      expect(controller.movies, mockMovies);
    });

    test('category selection should trigger new search', () async {
      final mockMovies = [
        Movie(
          title: 'Test Series',
          year: '2024',
          imdbID: 'series123',
          type: 'series',
          posterPath: 'series.jpg',
        ),
      ];

      when(mockRepository.searchMovies(
        query: 'movie',
        type: 'series',
      )).thenAnswer((_) async => mockMovies);

      controller.onCategorySelected('series');

      expect(controller.selectedCategory.value, 'series');
      await Future.delayed(const Duration(milliseconds: 100));
      expect(controller.movies, mockMovies);
    });
  });
} 