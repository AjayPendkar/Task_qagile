import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:qagile_task/app/data/repositories/movie_repository.dart';
import 'package:qagile_task/app/domain/entities/movie_details.dart';
import 'package:qagile_task/app/presentation/movie_details/controllers/movie_details_controller.dart';
import 'movie_details_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MovieRepository>()])

void main() {
  late MovieDetailsController controller;
  late MockMovieRepository mockRepository;

  setUp(() {
    mockRepository = MockMovieRepository();
    controller = MovieDetailsController(
      movieRepository: mockRepository,
      movieId: 'test123',
    );
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('MovieDetailsController Tests', () {
    test('initial values should be correct', () {
      expect(controller.isLoading.value, false);
      expect(controller.hasError.value, false);
      expect(controller.isSaved.value, false);
      expect(controller.isDownloading.value, false);
      expect(controller.downloadProgress.value, 0.0);
      expect(controller.movieDetails.value, MovieDetails.empty());
    });

    test('loadMovieDetails success should update values correctly', () async {
      final mockDetails = MovieDetails(
        title: 'Test Movie',
        year: '2024',
        rated: 'PG-13',
        released: '2024-03-15',
        runtime: '120 min',
       
        director: 'Test Director',
        writer: 'Test Writer',
        actors: 'Test Actor',
        plot: 'Test Plot',
        language: 'English',
        country: 'USA',
        awards: 'Test Awards',
        posterUrl: 'test.jpg',
        ratings: [],
       
        imdbRating: '8.0',
        imdbVotes: '1000',
        imdbID: 'test123',
        type: 'movie',
        boxOffice: '\$1M',
      
        genres: ['Action', 'Adventure'],
        metaScore: '80',
      );

      when(mockRepository.getMovieDetails('test123'))
          .thenAnswer((_) async => mockDetails);

      await controller.loadMovieDetails();

      expect(controller.isLoading.value, false);
      expect(controller.hasError.value, false);
      expect(controller.movieDetails.value, mockDetails);
    });

    test('loadMovieDetails failure should set error state', () async {
      when(mockRepository.getMovieDetails('test123'))
          .thenThrow(Exception('Test error'));

      await controller.loadMovieDetails();

      expect(controller.isLoading.value, false);
      expect(controller.hasError.value, true);
      expect(controller.movieDetails.value, MovieDetails.empty());
    });

    test('toggleSave should toggle saved state', () {
      expect(controller.isSaved.value, false);
      
      controller.toggleSave();
      expect(controller.isSaved.value, true);
      
      controller.toggleSave();
      expect(controller.isSaved.value, false);
    });

    test('startDownload should simulate download progress', () async {
      controller.startDownload();
      
      expect(controller.isDownloading.value, true);
      expect(controller.downloadProgress.value, 0.0);

      // Wait for simulated download to complete
      await Future.delayed(const Duration(seconds: 11));
      
      expect(controller.isDownloading.value, false);
      expect(controller.downloadProgress.value, 1.0);
    });
  });
} 