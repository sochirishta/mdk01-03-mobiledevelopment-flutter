import 'dart:convert';

enum NoteDialogMode { create, edit, view }

class Note {
  final int id;
  final String title;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toJson() => jsonEncode(toMap());

  factory Note.fromJson(String source) {
    final map = jsonDecode(source);
    return Note(
      id: map['id'],
      title: map['title'],
      text: map['text'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}

class SettingsState {
  final List<Note> notes;
  final bool isDarkMode;
  final int? selectedNoteId;

  SettingsState({
    required this.notes,
    required this.isDarkMode,
    required this.selectedNoteId,
  });

  factory SettingsState.initial() {
    return SettingsState(notes: [], isDarkMode: false, selectedNoteId: null);
  }

  SettingsState copyWith({
    List<Note>? notes,
    bool? isDarkMode,
    int? selectedNoteId,
  }) {
    return SettingsState(
      notes: notes ?? this.notes,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      selectedNoteId: selectedNoteId ?? this.selectedNoteId,
    );
  }
}
