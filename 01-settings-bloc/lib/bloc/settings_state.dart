enum AppTheme {
  light,
  dark,
}

class SettingsState {
  final String username;
  final AppTheme theme;

  SettingsState({
    required this.username,
    required this.theme,
  });

  SettingsState copyWith({String? username, AppTheme? theme,})
  {
    return SettingsState(
      username: username ?? this.username,
      theme: theme ?? this.theme,
    );
  }
}
