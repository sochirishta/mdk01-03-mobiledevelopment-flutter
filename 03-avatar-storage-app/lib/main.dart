import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avatar_storage_app/bloc/settings_state.dart';
import 'bloc/settings_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'bloc/settings_event.dart';

void main() {
  runApp(BlocProvider(
      create: (_) => SettingsBloc()..add(LoadSettings()),
      child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avatar Storage',
      theme: ThemeData.light(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> pickImage() async {
    final bloc = context.read<SettingsBloc>();
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    bloc.add(UpdateImage(bytes));
  }

  void removeImage() {
    context.read<SettingsBloc>().add(ClearImage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState> (
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Avatar Storage")),
          body: Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: state.avatarBytes != null
                      ? MemoryImage(state.avatarBytes!)
                      : const AssetImage('assets/images/img.png'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text("Pick image"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: removeImage,
                  child: const Text("Remove image"),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}