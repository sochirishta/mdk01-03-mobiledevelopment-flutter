import 'package:flutter/material.dart';
import 'post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Scrolling Post Feed'),
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
  List<Post> posts = [];
  int post = 0;
  final int listLimit = 15;
  final controller = ScrollController();
  bool isLoading = false;

  Future<List<Post>> getPosts(int post) async {
    await Future.delayed(const Duration(seconds: 1));
    final offset = post * listLimit + 1;
    return List.generate(listLimit, (i) {
      final id = offset+i;
      return Post(id: id, title: 'Пост $id', text: 'Описание поста $id');
    });
  }

  @override
  void initState() {
    super.initState();
    load();
    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent) {
        load();
      }
    });
  }

  Future<void> load() async {
    if (isLoading) return;
    isLoading = true;
    final result = await getPosts(post);
    setState(() {
      posts.addAll(result);
      post ++;
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        controller: controller,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ListTile(title: Text(post.title), subtitle: Text(post.text));
        },
      ),
    );
  }
}
