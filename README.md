<h1 align="center">📱 MDK 01-03 Mobile Development (Semester 5) </h1>

<p align="center">
This repository contains study works for the Mobile Development course (Semester 5).
The codebase is primarily based on college guidelines.
</p>

---

## .✦ ݁˖ Studies

- **[01-settings-bloc](./01-settings-bloc)** — Settings App (BLoC + SharedPreferences)
- **[02-gesture-tracker-app](./02-gesture-tracker-app)** — Gesture Tracker App using GestureDetector
- **[03-avatar-storage-app](./03-avatar-storage-app)** — Avatar Storage App using persistent image upload
- **[04-notes-bloc](./04-notes-bloc)** — Notes BLoC App (CRUD + Theme switching using ThemeData)
- **[05-firebase-auth](./05-firebase-auth)** — Firebase Auth App (login/registration using FirebaseAuth, StreamBuilder, authStateChanges)

---

## ˙⋆✮ Structure

Each work is stored in a separate folder and contains its own README with details and descriptions.

---

## ⋆✿˖ How to run projects

All projects in this repository are Flutter-based and follow the same setup:

```bash
flutter pub get
flutter run
```

## Notes

All dependencies are included, except Firebase configuration files (must be generated locally).
Firebase config files are not tracked in git.
Each user must generate their own Firebase configuration.

### Firebase setup (required for 05-firebase-auth)

1. Create a Firebase project: https://console.firebase.google.com
2. In the Flutter project folder, run:

```bash
flutter pub add firebase_core
```

3. Configure Firebase in your project:

```bash
flutterfire configure
```

*Here you must pick existing Firebase project or create new and pick platforms*

4. Initialize Firebase in `main.dart`:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

5. In the Firebase Console, under the **Authentication** section of your project summary, you can view the users who have registered through the app.

---

## ‎ꫂ᭪݁ Tech Stack

- Flutter
- Dart
- Firebase Authentication
- BLoC
- SharedPreferences

---

## 👤 Author

<p align="center">
Кошкин | йо: Кытин<br>
<a href="https://github.com/sochirishta">github.com/sochirishta</a>
</p>

---