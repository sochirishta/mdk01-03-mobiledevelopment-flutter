<h1 align="center">📱 MDK 01-03 Mobile Development Flutter Course</h1>

<p align="center">
This repository contains study works for the Mobile Development Flutter course.
The codebase is primarily based on college guidelines.
</p>

---

## .✦ ݁˖ Studies

#### - **[semester-5](./semester-5)**
- **[01-settings-bloc](./semester-5/01-settings-bloc)** — Settings App (BLoC + SharedPreferences)
- **[02-gesture-tracker-app](./semester-5/02-gesture-tracker-app)** — Gesture Tracker App using GestureDetector
- **[03-avatar-storage-app](./semester-5/03-avatar-storage-app)** — Avatar Storage App using persistent image upload
- **[04-notes-bloc](./semester-5/04-notes-bloc)** — Notes BLoC App (CRUD + Theme switching using ThemeData)
- **[05-firebase-auth](./semester-5/05-firebase-auth)** — Firebase Auth App (login/registration using FirebaseAuth, StreamBuilder, authStateChanges)
#### - **[semester-6](./semester-6)**
- **[06-scrolling-post-feed](./semester-6/06-scrolling-post-feed)** — Scrolling Post Feed (Infinite scroll using generate list)
- **[07-animated-widget](./semester-6/07-animated-widget)** — Animated Widget (Rectangle widget that change size and color by tap)
- **[08-firestore-crud](./semester-6/08-firestore-crud)** — Firestore Crud (Flutter, Firestore database and CRUD operations)

---

## ˙⋆✮ Structure

Each work is stored in a separate folder and contains its own README with details and descriptions.

---

## ⋆✿˖ How to run projects

All projects in this repository are Flutter-based. To run any of them, navigate to the project directory and execute:

```bash
flutter pub get
flutter run
```

## Notes

All dependencies are included, except Firebase configuration files (must be generated locally).
Firebase config files are not tracked in git.
Each user must generate their own Firebase configuration.
For the Firestore CRUD project, you must create a Firestore database in your Firebase project.

### Firebase setup (required for [05-firebase-auth](./semester-5/05-firebase-auth) and [08-firestore-crud](./semester-6/08-firestore-crud))

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

```bash
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

5. In the Firebase Console, under the **Authentication** section of your project summary, you can view the users who have registered through the app.

### Firestore setup (required for [08-firestore-crud](./semester-6/08-firestore-crud))

1. Create a Firestore database for your Firebase project
2. To install the FlutterFire CLI use:

```bash
dart pub global activate flutterfire_cli
```

3. Add FlutterFire CLI to PATH
4. Inside the Flutter project folder, run the following command to connect to your Firestore database:

```bash
flutterfire configure
```

---

## ‎ꫂ᭪݁ Tech Stack

- Flutter
- Dart
- Firebase Authentication
- BLoC
- SharedPreferences
- Firestore database

---

## 👤 Author

<p align="center">
Кошкин | йо: Кытин<br>
<a href="https://github.com/sochirishta">github.com/sochirishta</a>
</p>

---