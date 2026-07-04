import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState>{
  SettingsBloc(): super(SettingsState(username: '', theme: AppTheme.light,)) {
    on<UpdateName>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', event.username);
      emit(state.copyWith(username: event.username));
    });
    on<ToggleTheme>((event, emit) async {
      final newTheme = state.theme == AppTheme.light ? AppTheme.dark : AppTheme.light;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme', newTheme.name,);
      emit(state.copyWith(theme: newTheme));
    });
    on<LoadSettings>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? '';
      final themeString = prefs.getString('theme') ?? 'light';
      final theme = AppTheme.values.firstWhere((e) => e.name == themeString, orElse: () => AppTheme.light);
      emit(state.copyWith(username: username, theme: theme));
    });
    add(LoadSettings());
  }
}