import 'dart:typed_data';

abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent{}

class UpdateImage extends SettingsEvent {
  final Uint8List? avatarBytes;
  UpdateImage(this.avatarBytes);
}

class ClearImage extends SettingsEvent {}