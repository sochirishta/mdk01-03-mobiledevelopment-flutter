import 'dart:typed_data';

class SettingsState {
  final Uint8List? avatarBytes;

  SettingsState({
    this.avatarBytes,
  });

  SettingsState copyWith({
    Uint8List? avatarBytes,
  }) {
    return SettingsState(
      avatarBytes: avatarBytes ?? this.avatarBytes,
    );
  }
}