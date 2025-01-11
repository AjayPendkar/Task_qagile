import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../domain/entities/movie.dart';
import '../../../data/repositories/movie_repository_impl.dart';
import 'dart:async';

// Events
abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchMovies extends HomeEvent {
  final String query;
  SearchMovies(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadInitialMovies extends HomeEvent {}

class CategorySelected extends HomeEvent {
  final String category;
  CategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}

class ConnectivityChanged extends HomeEvent {
  final bool hasInternet;
  ConnectivityChanged(this.hasInternet);

  @override
  List<Object?> get props => [hasInternet];
}

class SearchMoviesDebounced extends HomeEvent {
  final String query;
  SearchMoviesDebounced(this.query);

  @override
  List<Object?> get props => [query];
}

// States
abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Movie> movies;
  final List<String> recentSearches;
  final String selectedCategory;
  final bool hasInternet;

  HomeLoaded({
    required this.movies,
    required this.recentSearches,
    required this.selectedCategory,
    required this.hasInternet,
  });

  @override
  List<Object?> get props => [movies, recentSearches, selectedCategory, hasInternet];

  HomeLoaded copyWith({
    List<Movie>? movies,
    List<String>? recentSearches,
    String? selectedCategory,
    bool? hasInternet,
  }) {
    return HomeLoaded(
      movies: movies ?? this.movies,
      recentSearches: recentSearches ?? this.recentSearches,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      hasInternet: hasInternet ?? this.hasInternet,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepositoryImpl movieRepository;
  final Connectivity connectivity;
  Timer? _debounceTimer;
  StreamSubscription? _connectivitySubscription;

  HomeBloc({
    required this.movieRepository,
    required this.connectivity,
  }) : super(HomeInitial()) {
    on<LoadInitialMovies>(_onLoadInitialMovies);
    on<SearchMovies>(_onSearchMovies);
    on<SearchMoviesDebounced>(_onSearchMoviesDebounced);
    on<CategorySelected>(_onCategorySelected);
    on<ConnectivityChanged>(_onConnectivityChanged);

    // Initialize connectivity listener
    _initConnectivity();
  }

  void _initConnectivity() async {
    try {
      print('🌐 Checking connectivity...');
      final result = await connectivity.checkConnectivity();
      final hasInternet = result != ConnectivityResult.none;
      print('📡 Internet connection: ${hasInternet ? 'Yes' : 'No'}');
      add(ConnectivityChanged(hasInternet));
      
      _connectivitySubscription = connectivity.onConnectivityChanged.listen((result) {
        final hasInternet = result != ConnectivityResult.none;
        print('🔄 Connectivity changed: ${hasInternet ? 'Connected' : 'Disconnected'}');
        add(ConnectivityChanged(hasInternet));
      });
    } catch (e) {
      print('❌ Connectivity error: $e');
    }
  }

  Future<void> _onLoadInitialMovies(
    LoadInitialMovies event,
    Emitter<HomeState> emit,
  ) async {
    print('🚀 Loading initial movies...');
    if (state is HomeLoaded && !(state as HomeLoaded).hasInternet) {
      print('❌ No internet connection');
      return;
    }

    emit(HomeLoading());
    try {
      print('📡 Fetching movies with query: Batman');
      final movies = await movieRepository.searchMovies(
        query: 'Batman',
        type: state is HomeLoaded ? (state as HomeLoaded).selectedCategory : 'movie',
      );
      print('✅ Found ${movies.length} movies');
      
      emit(HomeLoaded(
        movies: movies,
        recentSearches: state is HomeLoaded ? (state as HomeLoaded).recentSearches : [],
        selectedCategory: state is HomeLoaded ? (state as HomeLoaded).selectedCategory : 'movie',
        hasInternet: state is HomeLoaded ? (state as HomeLoaded).hasInternet : true,
      ));
    } catch (e) {
      print('❌ Error loading movies: $e');
      emit(HomeError('Failed to load movies: $e'));
    }
  }

  void _onSearchMovies(
    SearchMovies event,
    Emitter<HomeState> emit,
  ) {
    print('🔍 Search initiated: ${event.query}');
    
    if (state is! HomeLoaded) {
      print('⚠️ State is not HomeLoaded');
      return;
    }
    
    final currentState = state as HomeLoaded;
    if (!currentState.hasInternet) {
      print('❌ No internet for search');
      return;
    }

    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Don't skip empty queries
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      print('⏲️ Debounce timer triggered for: ${event.query}');
      add(SearchMoviesDebounced(event.query));
    });
  }

  Future<void> _onSearchMoviesDebounced(
    SearchMoviesDebounced event,
    Emitter<HomeState> emit,
  ) async {
    print('⏳ Processing search: ${event.query}');
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;

    try {
      print('🔍 Searching for: ${event.query}');
      final movies = await movieRepository.searchMovies(
        query: event.query.isEmpty ? 'Batman' : event.query, // Default to Batman if empty
        type: currentState.selectedCategory,
      );
      
      print('✅ Found ${movies.length} movies');

      // Only update if the event hasn't completed
      if (!emit.isDone) {
        var recentSearches = List<String>.from(currentState.recentSearches);
        if (!recentSearches.contains(event.query) && event.query.isNotEmpty) {
          recentSearches.insert(0, event.query);
          if (recentSearches.length > 5) recentSearches.removeLast();
          print('📝 Updated recent searches: $recentSearches');
        }

        emit(currentState.copyWith(
          movies: movies,
          recentSearches: recentSearches,
        ));
      }
    } catch (e) {
      print('❌ Search error: $e');
      print('🔄 Keeping current state due to error');
    }
  }

  void _onCategorySelected(
    CategorySelected event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(selectedCategory: event.category));
      add(LoadInitialMovies());
    }
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(hasInternet: event.hasInternet));
      if (event.hasInternet && currentState.movies.isEmpty) {
        add(LoadInitialMovies());
      }
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _debounceTimer?.cancel();
    return super.close();
  }
} 