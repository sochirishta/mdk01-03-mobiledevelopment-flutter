<h1 align="center">📱 Notes BLoC App </h1>

<p align="center">
A simple Flutter application that allows users to create, edit, delete and search notes. Notes are stored locally using SharedPreferences and restored after app restart.
The app also supports theme switching with persistent state.
</p>

---

## .✦ ݁˖ Features

- Create, edit, delete and search notes
- Theme switching (dark/light mode)
- Custom UI styling for light and dark themes using ThemeData
- Floating action buttons for main actions
- AlertDialog-based UI for all operations
- Persistent storage using SharedPreferences
- State restoration after app restart
- Single BLoC architecture for state management

---

## ˙⋆✮ How it works

The app is based on a single ListView that displays notes.
All actions (create, edit, delete, search, theme change) are handled via floating buttons and processed through BLoC.
State (notes + theme) is saved in SharedPreferences and restored on startup.
UI theme is dynamically applied using ThemeData, with separate design definitions for light and dark modes.

---

## ⋆✿˖ Project Structure

```text
lib/                     # Application source code (Dart, BLoC, UI)
├── bloc/                # State management (BLoC logic)
│   ├── settings_bloc.dart
│   ├── settings_event.dart
│   └── settings_state.dart
└── main.dart            # Application entry point

pubspec.yaml             # Dependencies and project config
```

---

## 👤 Author

<p align="center">
Кошкин | йо: Кытин<br>
<a href="https://github.com/sochirishta">github.com/sochirishta</a>
</p>

---