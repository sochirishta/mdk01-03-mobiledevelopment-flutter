abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class SaveSettings extends SettingsEvent {}

class AddNote extends SettingsEvent {
  final String title;
  final String text;

  AddNote({
    required this.title,
    required this.text,
  });
}

class GetNote extends SettingsEvent {
  final int id;

  GetNote(this.id);
}

class DeleteNote extends SettingsEvent {
  final int id;

  DeleteNote(this.id);
}

class EditNote extends SettingsEvent {
  final int id;
  final String title;
  final String text;

  EditNote({
    required this.id,
    required this.title,
    required this.text,
  });
}

class ToggleTheme extends SettingsEvent {

}