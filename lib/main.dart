import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'app/data/providers/api_client.dart';
import 'app/data/repositories/movie_repository_impl.dart';
import 'app/presentation/home/views/home_view.dart';
import 'core/constants/theme_constants.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  final prefs = await SharedPreferences.getInstance();
  final apiClient = ApiClient();
  final movieRepository = MovieRepositoryImpl(apiClient: apiClient);
  
  runApp(MyApp(
    prefs: prefs,
    movieRepository: movieRepository,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final MovieRepositoryImpl movieRepository;

  const MyApp({
    super.key,
    required this.prefs,
    required this.movieRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(prefs: prefs)..add(LoadTheme()),
        ),
        RepositoryProvider<MovieRepositoryImpl>(
          create: (context) => movieRepository,
        ),
        RepositoryProvider<Connectivity>(
          create: (context) => Connectivity(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return CupertinoApp(
            title: 'Movies App',
            theme: state.isDarkMode 
                ? ThemeConstants.darkTheme 
                : ThemeConstants.lightTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('es', 'ES'),
            ],
            debugShowCheckedModeBanner: false,
            home: const HomeView(),
            onGenerateRoute: AppPages.onGenerateRoute,
          );
        },
      ),
    );
  }
}
