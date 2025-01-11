import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToggleTheme extends ThemeEvent {}

class LoadTheme extends ThemeEvent {}

// States
class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences prefs;
  static const themeKey = 'isDarkMode';

  ThemeBloc({required this.prefs}) : super(ThemeState(isDarkMode: false)) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  void _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) {
    final isDarkMode = prefs.getBool(themeKey) ?? false;
    emit(ThemeState(isDarkMode: isDarkMode));
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final newValue = !state.isDarkMode;
    prefs.setBool(themeKey, newValue);
    emit(ThemeState(isDarkMode: newValue));
  }
} 