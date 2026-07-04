import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';
import 'dart:convert';
import 'dart:typed_data';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState()) {
    on<UpdateImage>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final bytes = base64Encode(event.avatarBytes!);
      await prefs.setString('avatarBytes', bytes);
      emit(state.copyWith(avatarBytes: event.avatarBytes));
    });
    on<ClearImage>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('avatarBytes');
      emit(SettingsState());
    });
    on<LoadSettings>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final bytes = prefs.getString('avatarBytes');
      Uint8List? avatarBytes;
      if (bytes != null) {
        avatarBytes = base64Decode(bytes);
      }
      emit(state.copyWith(avatarBytes: avatarBytes));
    });
  }
}