import 'package:get/get.dart';
import '../../../data/repositories/movie_repository.dart';
import '../../../domain/entities/movie.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeController extends GetxController {
  final MovieRepository movieRepository;
  final Connectivity connectivity;
  
  HomeController._({
    required this.movieRepository,
    required this.connectivity,
  });

  factory HomeController({
    required MovieRepository movieRepository,
    Connectivity? connectivity,
  }) {
    return HomeController._(
      movieRepository: movieRepository,
      connectivity: connectivity ?? Connectivity(),
    );
  }

  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;

  final movies = <Movie>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final selectedCategory = 'movie'.obs;
  final recentSearches = <String>[].obs;
  final hasInternet = true.obs;
  StreamSubscription? _connectivitySubscription;
  
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 500);

  // Add new properties for error states
  final isApiError = false.obs;
  final apiErrorMessage = ''.obs;

  final selectedTabIndex = 0.obs;

  final isScrolled = false.obs;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    loadInitialData();
    _initConnectivity();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _debounceTimer?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void onSearchQueryChanged(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // If empty, load initial data but maintain focus
    if (query.isEmpty) {
      loadInitialData();
      searchFocusNode.requestFocus();  // Keep focus
      return;
    }

    // Debounce search while maintaining focus
    _debounceTimer = Timer(_debounceDuration, () {
      _performSearch(query);
      searchFocusNode.requestFocus();  // Keep focus after search
    });
  }

  void onRecentSearchTap(String query) {
    searchController.text = query;
    // Set cursor at the end of text
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    searchFocusNode.requestFocus();
    _performSearch(query);
  }

  Future<void> _performSearch(String query) async {
    if (!hasInternet.value) return;
    
    try {
      isLoading.value = true;
      isApiError.value = false;  // Reset error state
      
      final results = await movieRepository.searchMovies(
        query: query,
        type: selectedCategory.value,
      );
      
      movies.value = results;
      
      // Add to recent searches
      if (query.isNotEmpty && !recentSearches.contains(query)) {
        recentSearches.insert(0, query);
        if (recentSearches.length > 5) {
          recentSearches.removeLast();
        }
      }

    } catch (e) {
      isApiError.value = true;
      if (e.toString().contains('not found')) {
        apiErrorMessage.value = 'No movies found for "$query"';
      } else if (e.toString().contains('timeout')) {
        apiErrorMessage.value = 'Request timed out. Please try again.';
      } else {
        apiErrorMessage.value = 'Something went wrong. Please try again.';
      }
      movies.clear();  // Clear movies on error
    } finally {
      isLoading.value = false;
    }
  }

  void onCategorySelected(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      // Maintain search focus when changing category
      if (searchController.text.isNotEmpty) {
        _performSearch(searchController.text);
      } else {
        loadInitialData();
      }
      searchFocusNode.requestFocus();
    }
  }

  Future<void> loadInitialData() async {
    if (!hasInternet.value) return;
    
    try {
      isLoading.value = true;
      isApiError.value = false;  // Reset error state
      
      final results = await movieRepository.searchMovies(
        query: 'movie',
        type: selectedCategory.value,
      );
      
      movies.value = results;

    } catch (e) {
      isApiError.value = true;
      if (e.toString().contains('timeout')) {
        apiErrorMessage.value = 'Connection timed out. Please try again.';
      } else {
        apiErrorMessage.value = 'Failed to load movies. Please try again.';
      }
      movies.clear();  // Clear movies on error
    } finally {
      isLoading.value = false;
    }
  }

  void clearRecentSearches() {
    recentSearches.clear();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      hasInternet.value = result != ConnectivityResult.none;
      
      _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
        hasInternet.value = result != ConnectivityResult.none;
        if (hasInternet.value && movies.isEmpty) {
          loadInitialData();
        }
      });
    } catch (e) {
      print('Connectivity error: $e');
    }
  }

  // Add method to retry last action
  void retryLastAction() {
    if (searchController.text.isNotEmpty) {
      _performSearch(searchController.text);
    } else {
      loadInitialData();
    }
  }

  void onTabSelected(int index) {
    selectedTabIndex.value = index;
    // Handle tab selection if needed
  }
} 