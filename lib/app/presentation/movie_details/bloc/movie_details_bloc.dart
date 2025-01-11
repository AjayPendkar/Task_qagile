import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/movie_details.dart';
import '../../../domain/repositories/movie_repository.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Events
abstract class MovieDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMovieDetails extends MovieDetailsEvent {
  final String movieId;
  LoadMovieDetails(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class ToggleSave extends MovieDetailsEvent {}

class ShareScreenshot extends MovieDetailsEvent {
  final GlobalKey screenshotKey;
  ShareScreenshot(this.screenshotKey);

  @override
  List<Object?> get props => [screenshotKey];
}

class StartDownload extends MovieDetailsEvent {}

// States
abstract class MovieDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetails details;
  final bool isSaved;
  final bool isDownloading;
  final double downloadProgress;

  MovieDetailsLoaded({
    required this.details,
    required this.isSaved,
    required this.isDownloading,
    required this.downloadProgress,
  });

  @override
  List<Object?> get props => [details, isSaved, isDownloading, downloadProgress];

  MovieDetailsLoaded copyWith({
    MovieDetails? details,
    bool? isSaved,
    bool? isDownloading,
    double? downloadProgress,
  }) {
    return MovieDetailsLoaded(
      details: details ?? this.details,
      isSaved: isSaved ?? this.isSaved,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }
}

class MovieDetailsError extends MovieDetailsState {
  final String message;
  MovieDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieRepository movieRepository;
  Timer? _downloadTimer;

  MovieDetailsBloc({required this.movieRepository}) : super(MovieDetailsInitial()) {
    on<LoadMovieDetails>(_onLoadMovieDetails);
    on<ToggleSave>(_onToggleSave);
    on<ShareScreenshot>(_onShareScreenshot);
    on<StartDownload>(_onStartDownload);
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetails event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoading());
    try {
      print('🎬 Loading details for movie ID: ${event.movieId}');
      final details = await movieRepository.getMovieDetails(event.movieId);
      print('🖼️ Poster URL: ${details.posterUrl}');
      
      emit(MovieDetailsLoaded(
        details: details,
        isSaved: false,
        isDownloading: false,
        downloadProgress: 0.0,
      ));
    } catch (e) {
      print('❌ Error loading movie details: $e');
      emit(MovieDetailsError('Failed to load movie details'));
    }
  }

  void _onToggleSave(
    ToggleSave event,
    Emitter<MovieDetailsState> emit,
  ) {
    if (state is MovieDetailsLoaded) {
      final currentState = state as MovieDetailsLoaded;
      emit(currentState.copyWith(isSaved: !currentState.isSaved));
    }
  }

  Future<void> _onShareScreenshot(
    ShareScreenshot event,
    Emitter<MovieDetailsState> emit,
  ) async {
    if (state is! MovieDetailsLoaded) return;

    try {
      final boundary = event.screenshotKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/movie_screenshot.png')
            .writeAsBytes(byteData.buffer.asUint8List());
        await Share.shareXFiles([XFile(file.path)]);
      }
    } catch (e) {
      // Handle error
    }
  }

  void _onStartDownload(
    StartDownload event,
    Emitter<MovieDetailsState> emit,
  ) {
    if (state is! MovieDetailsLoaded) return;
    final currentState = state as MovieDetailsLoaded;
    
    if (currentState.isDownloading) return;
    
    emit(currentState.copyWith(
      isDownloading: true,
      downloadProgress: 0.0,
    ));

    _downloadTimer?.cancel();
    _downloadTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is MovieDetailsLoaded) {
        final current = state as MovieDetailsLoaded;
        if (current.downloadProgress < 1.0) {
          emit(current.copyWith(
            downloadProgress: current.downloadProgress + 0.1,
          ));
        } else {
          timer.cancel();
          emit(current.copyWith(
            isDownloading: false,
            downloadProgress: 1.0,
          ));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _downloadTimer?.cancel();
    return super.close();
  }
} 