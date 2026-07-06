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
  Map<String, dynamic>? _selectedNoteData;

  void _selectNote(String docId, Map<String, dynamic> data) {
    setState(() {
      _selectedDocId = docId;
      _selectedNoteData = data;
    });
  }

  Future<void> _addNote(BuildContext context) async {
    final titleController = TextEditingController();
    final textController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Text'),
              minLines: 2,
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != true) return;

    await _notes.add({
      'title': titleController.text,
      'text': textController.text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _editNote(BuildContext context, String docId, Map<String, dynamic> data) async {

    final titleController = TextEditingController(text: data['title']);
    final textController = TextEditingController(text: data['text']);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: 'Text'),
              minLines: 2,
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != true) return;

    final newTitle = titleController.text.trim();
    final newText = textController.text.trim();

    await _notes.doc(docId).update({
      'title': newTitle,
      'text': newText,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _deleteNote(BuildContext context, String docId) async {
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

    if (ok != true) return;

    await _notes.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _notes.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
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
                      title: Text(data.data()['title'] ?? ''),
                      subtitle: Text(data.data()['text'] ?? ''),
                      selected: isSelected,
                      selectedTileColor: Colors.blue.withOpacity(0.1),
                      onTap: () => _selectNote(data.id, data.data())
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
                onPressed: () => _addNote(context),
                tooltip: 'Create',
                child: const Icon(Icons.add_circle),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                onPressed: _selectedDocId == null
                    ? null
                    : () {
                  _editNote(context, _selectedDocId!, _selectedNoteData!);
                      },
                tooltip: 'Edit',
                child: const Icon(Icons.edit),
              ),
              const SizedBox(height: 12),
              FloatingActionButton(
                onPressed: _selectedDocId == null
                    ? null
                    : () {
                        _deleteNote(context, _selectedDocId!);
                      },
                tooltip: 'Delete',
                child: const Icon(Icons.delete),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}