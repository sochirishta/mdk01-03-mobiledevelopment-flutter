import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/settings_bloc.dart';
import 'bloc/settings_state.dart';
import 'bloc/settings_event.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => SettingsBloc()..add(LoadSettings()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'BLoC Settings',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: state.theme == AppTheme.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const HomePage(),
        );
      },
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});
    @override
    Widget build(BuildContext context) {
      return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('BLoC Settings'),
            ),

            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    'Имя: ${state.username}',
                    style: const TextStyle(fontSize: 24),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Введите имя',
                    ),
                    onChanged: (value) {
                      context
                          .read<SettingsBloc>()
                          .add(UpdateName(value));
                    },
                  ),

                  const SizedBox(height: 20),

                  Switch(
                    value: state.theme == AppTheme.dark,
                    onChanged: (_) {
                      context
                          .read<SettingsBloc>()
                          .add(ToggleTheme());
                    },
                  ),

                  Text(
                    state.theme == AppTheme.dark
                        ? 'Тёмная тема'
                        : 'Светлая тема',
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
}