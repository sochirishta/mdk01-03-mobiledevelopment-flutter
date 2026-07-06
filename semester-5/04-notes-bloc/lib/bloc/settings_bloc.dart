import 'dart:convert';

import 'settings_state.dart';
import 'settings_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.initial()) {
    on<LoadSettings>(_onLoadSettings);
    on<AddNote>(_onAddNote);
    on<EditNote>(_onEditNote);
    on<DeleteNote>(_onDeleteNote);
    on<ToggleTheme>(_onToggleTheme);
    on<GetNote>(_onGetNote);
  }

  void _onGetNote(GetNote event, Emitter<SettingsState> emit) {
    final newSelected = state.selectedNoteId == event.id
        ? null
        : event.id;
    emit(state.copyWith(
      selectedNoteId: newSelected,
    ));
  }

  Future<void> _saveSettings(SettingsState state) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonNotes = state.notes
        .map((note) => jsonEncode(note.toJson()))
        .toList();
    await prefs.setStringList('notes', jsonNotes);
    await prefs.setBool('isDarkMode', state.isDarkMode);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final stateData = await _loadSettings();
    emit(stateData);
  }

  Future<void> _onAddNote(AddNote event, Emitter<SettingsState> emit) async {
    final notes = List<Note>.from(state.notes);
    final note = Note(
      id: DateTime.now().microsecondsSinceEpoch,
      title: event.title,
      text: event.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    notes.add(note);
    final newState = state.copyWith(notes: notes);
    emit(newState);
    await _saveSettings(newState);
  }

  Future<void> _onEditNote(EditNote event, Emitter<SettingsState> emit) async {
    final oldNote = state.notes.firstWhere((note) => note.id == event.id);
    final updatedNote = Note(
      id: event.id,
      title: event.title,
      text: event.text,
      createdAt: oldNote.createdAt,
      updatedAt: DateTime.now(),
    );
    final notes = state.notes
        .map((note) => note.id == event.id ? updatedNote : note)
        .toList();
    final newState = state.copyWith(notes: notes);
    emit(newState);
    await _saveSettings(newState);
  }

  Future<void> _onDeleteNote(
    DeleteNote event,
    Emitter<SettingsState> emit,
  ) async {
    final notes = List<Note>.from(state.notes);
    notes.removeWhere((note) => note.id == event.id);
    final newState = state.copyWith(notes: notes);
    emit(newState);
    await _saveSettings(newState);
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<SettingsState> emit,
  ) async {
    final newValue = !state.isDarkMode;
    final newState = state.copyWith(isDarkMode: newValue);
    emit(newState);
    await _saveSettings(newState);
  }

  Future<SettingsState> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonNotes = prefs.getStringList('notes') ?? [];
    final isDark = prefs.getBool('isDarkMode') ?? false;
    return SettingsState(
      notes: jsonNotes.map((note) => Note.fromJson(jsonDecode(note))).toList(),
      isDarkMode: isDark,
      selectedNoteId: null,
    );
  }
}
