<h1 align="center">📱 Avatar Storage App</h1> 

<p align="center">
A simple Flutter application that demonstrates BLoC state management and persistent storage for saving and restoring user-uploaded images. 
</p>

---

## .✦ ݁˖ Features

- Image uploading using ImagePicker
- Image removing (reset to default avatar)
- Default avatar stored in project assets
- State management using BLoC pattern
- Persistent storage using SharedPreferences
- State restoration after app restart

---

## ⋆✿˖ Project Structure

```text
assets/
└── images/              # Default avatars and placeholder images
    └── img.png

lib/                     # Application source code (Dart, BLoC, UI)
├── bloc/                # State management (BLoC logic)
│   ├── avatar_bloc.dart
│   ├── avatar_event.dart
│   └── avatar_state.dart
└── main.dart            # Application entry point and UI screens

pubspec.yaml             # Project dependencies and configuration
```

---

## Notes

- Images are stored locally using SharedPreferences
- Application state is restored on restart
- Default avatar is used when no image is selected

---

## 👤 Author

<p align="center">
Кошкин | йо: Кытин<br>
<a href="https://github.com/sochirishta">github.com/sochirishta</a>
</p>

---