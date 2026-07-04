<h1 align="center">📱 Firebase Auth App </h1>

<p align="center">
A simple Flutter application that uses Firebase Authentication for user registration and login.
</p>

---

## .✦ ݁˖ Features

- User registration and login (email & password)
- Single unified authentication dialog (login ↔ register switch)
- Inline error messages under inputs in authentication dialog
- Logout
- Reactive UI using StreamBuilder (`authStateChanges`)
- Persistent login state (user stays signed in after app restart)

---

## ˙⋆✮ How it works

The app uses Firebase Authentication state to control the UI.
It follows a **single-screen architecture**:

- If `user == null` -> "Welcome, guest"
- If `user != null` -> "Welcome, user.email"

Authentication happens inside a single `AlertDialog`, where the user can switch between login and registration modes.
Errors are displayed directly under the input fields inside the dialog.
Firebase automatically tracks user state and updates the UI through `StreamBuilder`.

---

## ⋆✿˖ Project Structure

```text                
lib/                     
├── auth_service.dart       # Firebase auth logic (register, login, logout)
├── firebase_options.dart   # Firebase configurations [Generated locally / Ignored]
└── main.dart               # Entry point of the application and UI screens

pubspec.yaml                # Project dependencies (firebase_core, firebase_auth, etc.)
```

---

## 👤 Author

<p align="center">
Кошкин | йо: Кытин<br>
<a href="https://github.com/sochirishta">github.com/sochirishta</a>
</p>

---