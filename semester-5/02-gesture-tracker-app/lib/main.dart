import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GestureHomePage(),
    );
  }
}

class GestureHomePage extends StatefulWidget {
  const GestureHomePage({super.key});
  @override
  State<GestureHomePage> createState() => _GestureHomePageState();
}

class _GestureHomePageState extends State<GestureHomePage> {
  int _counter = 0;
  String _message = "Попробуй жест";
  List<String> history = [];
  double _scale = 1.0;
  double _previousScale = 1.0;
  double _previousRotation = 0.0;
  double _rotation = 0.0;

  Offset total = Offset.zero;
  Color _color = Colors.white;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _setMessage(String text) {
    setState(() {
      _message = text;
    });
  }

  void _changeColor(Color color) {
    setState(() {
      _color = color;
    });
  }

  void _history(String message) {
    setState(() {
      history.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gesture Tracker")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Счетчик жестов: $_counter',
            style: const TextStyle(fontSize: 18),
          ),
          // - Жесты
          GestureDetector(
            onTap: () {
              _setMessage("Обнаружен тап");
              _increment();
              _changeColor(Colors.white);
              _history(_message);
            },
            onDoubleTap: () {
              _setMessage("Обнаружен двойной тап");
              _increment();
              _changeColor(Colors.white);
              _history(_message);
            },
            onLongPress: () {
              _setMessage("Обнаружено долгое нажатие");
              _increment();
              _changeColor(Colors.white);
              _history(_message);
            },
            onScaleStart: (details) {
              _previousScale = _scale;
              _previousRotation = _rotation;
              total = Offset.zero;
            },
            onScaleUpdate: (details) {
              setState(() {
                _scale = (_previousScale * details.scale).clamp(0.5, 1.5);
                _rotation = (_previousRotation + details.rotation);
                total += details.focalPointDelta;
                if (_scale != _previousScale ||
                    _rotation != _previousRotation) {
                  _setMessage(
                    "Масштаб: x${_scale.toStringAsFixed(2)}, Поворот: ${_rotation.toStringAsFixed(2)} рад",
                  );
                }
              });
            },
            onScaleEnd: (details) {
              if (_scale != _previousScale || _rotation != _previousRotation) {
                if (_scale > _previousScale) {
                  _setMessage(
                    "Произведено увеличение объекта\nи поворот объекта на ${_rotation.toStringAsFixed(2)} рад",
                  );
                } else if (_scale < _previousScale) {
                  _setMessage(
                    "Произведено уменьшение объекта\nи поворот объекта на ${_rotation.toStringAsFixed(2)} рад",
                  );
                } else {
                  _setMessage(
                    "Произведен поворот объекта на\n${_rotation.toStringAsFixed(2)} рад",
                  );
                }
              } else {
                if (total.dx.abs() > total.dy.abs()) {
                  if (total.dx > 0) {
                    _setMessage("Свайп вправо");
                    _changeColor(Colors.red);
                  } else {
                    _setMessage("Свайп влево");
                    _changeColor(Colors.green);
                  }
                } else {
                  if (total.dy > 0) {
                    _setMessage("Свайп вниз");
                    _changeColor(Colors.blue);
                  } else {
                    _setMessage("Свайп вверх");
                    _changeColor(Colors.yellow);
                  }
                }
              }
              _increment();
              _history(_message);
            },
            child: ClipRect(
              child: Transform.scale(
                scale: _scale,
                child: Transform.rotate(
                  angle: _rotation,
                  // - Участок для жестов
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: Text(
                      _message,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(history[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}