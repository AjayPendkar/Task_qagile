import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../../../data/repositories/movie_repository_impl.dart';
import '../../shared/widgets/shimmer_loading.dart';
import '../../shared/widgets/no_internet_view.dart';
import '../widgets/movie_grid.dart';
import '../widgets/search_field.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        movieRepository: context.read<MovieRepositoryImpl>(),
        connectivity: context.read<Connectivity>(),
      )..add(LoadInitialMovies()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildLoadingState();
          }
          
          if (state is HomeLoaded) {
            return _buildContent(context, state);
          }
          
          if (state is HomeError) {
            return _buildErrorState(context, state.message);
          }
          
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return CupertinoPageScaffold(
      child: Center(
        child: ShimmerLoading(
          width: double.infinity,
          height: 100.0,
          isLoading: true,
          widget: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, __) => const Card(
              child: SizedBox(height: 100),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeLoaded state) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: SearchField(
          onChanged: (query) {
            context.read<HomeBloc>().add(SearchMovies(query));
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Category filters
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['movie', 'series', 'episode'].map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.read<HomeBloc>().add(CategorySelected(category));
                      },
                      child: Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          color: state.selectedCategory == category
                              ? CupertinoColors.activeBlue
                              : CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Movies grid
            if (!state.hasInternet)
              const NoInternetView()
            else if (state.movies.isEmpty)
              const Center(child: Text('No movies found'))
            else
              Expanded(
                child: MovieGrid(movies: state.movies),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            CupertinoButton(
              child: const Text('Retry'),
              onPressed: () {
                context.read<HomeBloc>().add(LoadInitialMovies());
              },
            ),
          ],
        ),
      ),
    );
  }
} 
