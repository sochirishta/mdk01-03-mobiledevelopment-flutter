<h1 align="center">📱 Gesture Tracker App </h1>

<p align="center">
A simple Flutter application that demonstrates gesture detection and state handling in a single-screen architecture.
</p>

---

## .✦ ݁˖ Features

- Tap detection
- Double tap detection
- Long press detection
- Swipe detection (up, down, left, right) with dynamic color changes
- Scale (zoom in / zoom out) and rotation gestures with combined handling
- Gesture message updates and history log of it using ListView
- Counter of gestures

---

## ˙⋆✮ How it works

The app is built around a single interactive square widget.
All gestures are handled using Flutter's `GestureDetector`.
Each gesture triggers state updates inside a `StatefulWidget`:

- Tap events update counter and message
- Scale gestures modify size and rotation
- Swipe gestures are detected based on movement direction
- Every action is logged into a history list

The history is displayed in real time using a `ListView`.

---

## ꫂ ၴႅၴ Gesture Logic

The app uses a combination of Flutter gesture callbacks:

- `onTap`
- `onDoubleTap`
- `onLongPress`
- `onScaleStart`
- `onScaleUpdate`
- `onScaleEnd`

Swipe direction is determined by comparing movement delta:

- Horizontal vs vertical movement
- Positive/negative axis direction

Scale and rotation are handled simultaneously using `GestureDetector` scale callbacks.

---

## ⋆✿˖ Project Structure

```text
lib/                     
└── main.dart            # UI + gesture logic + history tracking

pubspec.yaml             # Dependencies and project config
```

---

## Known Issues

- Gesture conflicts may occur between swipe, scale, and rotation detection
- Swipe detection is calculated after gesture end, not in real-time
- Gesture priority system is not implemented
- All logic is contained in a single StatefulWidget (not scalable architecture)

---

## 👤 Author

<p align="center">
Кошкин | йо: Кытин<br>
<a href="https://github.com/sochirishta">github.com/sochirishta</a>
</p>

---