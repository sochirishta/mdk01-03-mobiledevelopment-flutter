import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Firestore CRUD'),
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
  final _notes = FirebaseFirestore.instance.collection('notes');

  String? _selectedDocId;

  static const int modeCreate = 1;
  static const int modeEdit = 2;
  static const int modeView = 3;

  Future<void> _getNote(
    int dialogMode,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final titleController = TextEditingController(text: data['title']);
    final textController = TextEditingController(text: data['text']);

    String? errorMessage;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                dialogMode == modeCreate
                    ? "Create Note"
                    : dialogMode == modeEdit
                    ? "Edit Note"
                    : "${data['title']}",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    readOnly: dialogMode == modeView,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: textController,
                    readOnly: dialogMode == modeView,
                    decoration: const InputDecoration(labelText: 'Text'),
                    minLines: 2,
                    maxLines: 5,
                  ),
                  if (dialogMode == modeView || dialogMode == modeEdit) ...[
                    Text("Created at: ${data['createdAt']?.toDate() ?? '-'}"),
                    Text("Updated at: ${data['updatedAt']?.toDate() ?? '-'}"),
                  ],
                  if (errorMessage?.isNotEmpty == true) ...[
                    Text("Error: $errorMessage",
                    style: const TextStyle(color: Colors.red,),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (dialogMode == modeCreate || dialogMode == modeEdit) {
                      if (titleController.text.trim().isEmpty ||
                          textController.text.trim().isEmpty) {
                        setDialogState(() {
                          errorMessage = 'Fields are blank';
                        });
                      } else {
                        Navigator.pop(context, true);
                      }
                    } else {
                      final deleted = await _deleteNote(docId);
                      if (!context.mounted) return;
                      if (deleted) {
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  child: Text(
                    dialogMode == modeCreate
                        ? "Create"
                        : dialogMode == modeEdit
                        ? "Edit note"
                        : "Delete note",
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true) return;
    if (dialogMode == modeCreate) {
      await _notes.add({
        'title': titleController.text.trim(),
        'text': textController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else if (dialogMode == modeEdit) {
      await _notes.doc(docId).update({
        'title': titleController.text.trim(),
        'text': textController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> _deleteNote(String docId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('You want to delete a note?'),
        content: const Text('This action is not support undo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, delete it.'),
          ),
        ],
      ),
    );

    if (ok != true) return false;

    await _notes.doc(docId).delete();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _notes.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final notes = snapshot.data!.docs;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final data = notes[index];
                    final isSelected = data.id == _selectedDocId;

                    return ListTile(
                      title: Text(data['title'] ?? ''),
                      subtitle: Text(data['text'] ?? ''),
                      selected: isSelected,
                      selectedTileColor: Colors.blue.withValues(alpha: 0.1),
                      onTap: () {
                        setState(() {
                          _selectedDocId = isSelected ? null : data.id;
                        });
                      },
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
                onPressed: () => _getNote(modeCreate, '', {}),
                tooltip: 'Create',
                child: const Icon(Icons.add_circle),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                onPressed: _selectedDocId == null
                    ? null
                    : () {
                        final selectedDoc = notes.firstWhere(
                          (d) => d.id == _selectedDocId,
                        );
                        _getNote(
                          modeEdit,
                          selectedDoc.id,
                          selectedDoc.data() as Map<String, dynamic>,
                        );
                      },
                tooltip: 'Edit',
                child: const Icon(Icons.edit),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                onPressed: _selectedDocId == null
                    ? null
                    : () {
                        final selectedDoc = notes.firstWhere(
                          (d) => d.id == _selectedDocId,
                        );
                        _getNote(
                          modeView,
                          selectedDoc.id,
                          selectedDoc.data() as Map<String, dynamic>,
                        );
                      },
                tooltip: 'Delete',
                child: const Icon(Icons.open_in_new),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
