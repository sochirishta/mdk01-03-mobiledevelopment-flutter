abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent{}

class UpdateName extends SettingsEvent {
  final String username;
  UpdateName(this.username);
}

class ToggleTheme extends SettingsEvent {}