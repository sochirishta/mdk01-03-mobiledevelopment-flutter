import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_bloc_app/bloc/settings_bloc.dart';
import 'package:notes_bloc_app/bloc/settings_event.dart';
import 'package:notes_bloc_app/bloc/settings_state.dart';

void main() async {
  runApp(
    BlocProvider(
      create: (_) => SettingsBloc()..add(LoadSettings()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Notes BLoC',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.black)),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.cyanAccent,
            ),
            cardTheme: CardThemeData(
              color: Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: Colors.white70,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.deepPurple),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.lightGreenAccent,
              foregroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            cardTheme: CardThemeData(
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MyHomePage(title: 'Заметки с темами'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _note(NoteDialogMode mode, Note? note) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final textController = TextEditingController(text: note?.text ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            mode == NoteDialogMode.create
                ? "Создание заметки"
                : mode == NoteDialogMode.edit
                ? "Редактирование заметки"
                : "Просмотр",
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200, maxWidth: 100),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text ("Название"),
                  const SizedBox(height: 6),
                  TextField(
                    maxLines: null,
                    readOnly: mode == NoteDialogMode.view,
                    keyboardType: TextInputType.multiline,
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Введите название",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text ("Текст заметки"),
                  const SizedBox(height: 6),
                  SizedBox(height: 200,
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    controller: textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Введите текст",
                    ),
                  ),
                  ),
                  const SizedBox(height: 12),
                  if (note != null &&
                      (mode == NoteDialogMode.edit ||
                          mode == NoteDialogMode.view)) ...[
                    Text("Создана: ${note.createdAt.toString()}"),
                    const SizedBox(height: 12),
                    Text("Обновлена: ${note.updatedAt.toString()}"),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                if (mode == NoteDialogMode.create) {
                  context.read<SettingsBloc>().add(
                    AddNote(
                      title: titleController.text,
                      text: textController.text,
                    ),
                  );
                }
                if (mode == NoteDialogMode.edit) {
                  if (note == null) return;
                  context.read<SettingsBloc>().add(
                    EditNote(
                      id: note.id,
                      title: titleController.text,
                      text: textController.text,
                    ),
                  );
                }
                if (mode == NoteDialogMode.view) {
                  if (note == null) return;
                  context.read<SettingsBloc>().add(DeleteNote(note.id));
                }
                Navigator.pop(context);
              },
              child: Text(
                mode == NoteDialogMode.create
                    ? "Создать"
                    : mode == NoteDialogMode.edit
                    ? "Сохранить изменения"
                    : "Удалить заметку",
              ),
            ),
          ],
        );
      },
    );
  }

  void _searchNote() {
    final state = context.read<SettingsBloc>().state;
    List<Note> filteredNotes = List.from(state.notes);
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Поиск"),
              content: SizedBox(
                width: 350,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Введите текст",
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          filteredNotes = state.notes.where((note) {
                            return note.title.toLowerCase().contains(
                                  value.toLowerCase(),
                                ) ||
                                note.text.toLowerCase().contains(
                                  value.toLowerCase(),
                                );
                          }).toList();
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = filteredNotes[index];
                          final selectedId = context
                              .watch<SettingsBloc>()
                              .state
                              .selectedNoteId;
                          final isSelected = selectedId == note.id;
                          return Card(
                            color: isSelected
                                ? Colors.grey.shade800
                                : Theme.of(context).cardTheme.color,
                            child: ListTile(
                              title: Text(note.title),
                              onTap: () {
                                if (isSelected) {
                                  Navigator.pop(context);
                                  _openNote(note.id);
                                } else {
                                  context.read<SettingsBloc>().add(
                                    GetNote(note.id),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Закрыть"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openNote(int id) {
    context.read<SettingsBloc>().state.notes;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(widget.title),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.notes.length,
                  itemBuilder: (context, index) {
                    final note = state.notes[index];
                    final isSelected = state.selectedNoteId == note.id;
                    return Card(
                      elevation: isSelected ? 8 : 2,
                      color: isSelected
                          ? Colors.grey.shade800
                          : Theme.of(context).cardTheme.color,
                      child: ListTile(
                        title: Text(note.title),
                        onTap: () {
                          context.read<SettingsBloc>().add(GetNote(note.id));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () => _note(NoteDialogMode.create, null),
                tooltip: 'Create',
                child: const Icon(Icons.add_circle),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                onPressed: state.selectedNoteId == null
                    ? null
                    : () {
                        final note = state.notes.firstWhere(
                          (note) => note.id == state.selectedNoteId,
                        );
                        _note(NoteDialogMode.edit, note);
                      },
                tooltip: 'Edit',
                child: const Icon(Icons.edit),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                onPressed: state.selectedNoteId == null
                    ? null
                    : () {
                        final note = state.notes.firstWhere(
                          (note) => note.id == state.selectedNoteId,
                        );
                        _note(NoteDialogMode.view, note);
                      },
                tooltip: 'View',
                child: const Icon(Icons.open_in_new),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                onPressed: () {
                  context.read<SettingsBloc>().add(ToggleTheme());
                },
                child: Icon(
                  state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                onPressed: _searchNote,
                tooltip: 'Search',
                child: Icon(Icons.search),
              ),
            ],
          ),
        );
      },
    );
  }
}
