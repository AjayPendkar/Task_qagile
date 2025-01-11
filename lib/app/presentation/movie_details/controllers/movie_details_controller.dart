import 'package:get/get.dart';
import 'package:qagile_task/core/constants/theme_constants.dart';
import '../../../data/repositories/movie_repository.dart';
import '../../../domain/entities/movie_details.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MovieDetailsController extends GetxController {
  final MovieRepository movieRepository;
  final String movieId;

  MovieDetailsController({
    required this.movieRepository,
    required this.movieId,
  });

  final movieDetails = MovieDetails.empty().obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final isSaved = false.obs;
  final isDownloading = false.obs;
  final downloadProgress = 0.0.obs;
  final GlobalKey screenshotKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    loadMovieDetails();
  }

  Future<void> loadMovieDetails() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final details = await movieRepository.getMovieDetails(movieId);
      movieDetails.value = details;
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSave() {
    isSaved.toggle();
    Get.snackbar(
      'Success',
      isSaved.value ? 'Movie saved' : 'Movie removed from saved',
      duration: const Duration(seconds: 2),
      backgroundColor: ThemeConstants.primaryNavyBlue,
      colorText: CupertinoColors.white,
    );
  }

  Future<void> shareScreenshot() async {
    try {
      // Capture screenshot
      RenderRepaintBoundary boundary = screenshotKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        // Get temporary directory to save image
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/movie_screenshot.png')
            .writeAsBytes(byteData.buffer.asUint8List());

        // Share with text and image
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Check out ${movieDetails.value.title}!\n'
              'Year: ${movieDetails.value.year}\n'
              'Rating: ${movieDetails.value.imdbRating}/10\n'
              '\nShared via Movies App',
          subject: movieDetails.value.title,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share screenshot',
        duration: const Duration(seconds: 2),
        backgroundColor: CupertinoColors.systemRed,
        colorText: CupertinoColors.white,
      );
    }
  }

  // Add method to share without screenshot
  void shareMovie() {
    try {
      Share.share(
        'Check out ${movieDetails.value.title}!\n'
        'Year: ${movieDetails.value.year}\n'
        'Rating: ${movieDetails.value.imdbRating}/10\n'
        '\nShared via Movies App',
        subject: movieDetails.value.title,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share movie',
        duration: const Duration(seconds: 2),
        backgroundColor: CupertinoColors.systemRed,
        colorText: CupertinoColors.white,
      );
    }
  }

  Future<void> startDownload() async {
    if (isDownloading.value) return;

    isDownloading.value = true;
    downloadProgress.value = 0.0;

    Get.snackbar(
      'Download',
      'Download started',
      duration: const Duration(seconds: 2),
      backgroundColor: ThemeConstants.primaryNavyBlue,
      colorText: CupertinoColors.white,
    );

    // Simulate download progress
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (downloadProgress.value < 1.0) {
        downloadProgress.value += 0.1;
      } else {
        timer.cancel();
        isDownloading.value = false;
        Get.snackbar(
          'Download',
          'Download completed successfully',
          duration: const Duration(seconds: 2),
          backgroundColor: ThemeConstants.primaryNavyBlue,
          colorText: CupertinoColors.white,
        );
      }
    });
  }
} 