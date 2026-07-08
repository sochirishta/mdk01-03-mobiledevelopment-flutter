<h1 align="center">📱 Firestore CRUD V2 </h1>

<p align="center">
A simple Flutter application that uses Firebase Authentication for user registration and login, and Cloud Firestore to store and manage data for a demo e-commerce application.
</p>

---

## .✦ ݁˖ Features

- User registration and login (email & password)
- Single unified authentication dialog (login ↔ register switch)
- Inline error messages under inputs in authentication dialog
- Logout
- Reactive UI using StreamBuilder (`authStateChanges`)
- Persistent login state (user stays signed in after app restart)
- Product catalog loaded from Cloud Firestore
- Shopping cart data stored in Cloud Firestore
- Add products to the shopping cart
- Remove products from the shopping cart

---

## ˙⋆✮ How it works

The app uses Cloud Firestore to store product and cart data.
Registering a new user creates a cart document with the user’s `ID`. This document stores product `IDs` as fields when items are added to the cart.

The catalog and shopping cart are implemented in a single widget. Product data is loaded in
`initState()`, while a `StreamBuilder` listens for cart updates. Authentication state is managed with
`authStateChanges()`.

Adding a product to the cart decreases its quantity in the catalog and increases its quantity in the
shopping cart. Removing a product from cart restores the catalog quantity and decreases the cart quantity.
When the quantity of a product in the cart reaches zero, its fields in the cart document is automatically deleted.

---

## ⋆✿˖ Project Structure

```text                
lib/                     
├── auth_service.dart       # Firebase auth logic (register, login, logout, cart updates)
├── firebase_options.dart   # Firebase configurations [Generated locally / Ignored]
├── login_dialog.dart       # Authentication dialog for registration/login
└── main.dart               # Entry point of the application and UI screens

pubspec.yaml                # Project dependencies (firebase_core, firebase_auth, cloud_firestore, etc.)
```

---

## ⋆✿˖ Cloud Firestore Structure

```text                
Cloud Firestore > Database
├── users                         # Collection to store registered users data
│      └── [user_uid]             # Document ID = Firebase Authentication UID
│               ├── email: "user@example.com" (String)
│               └── createdAt: Timestamp
├── products                      # Collection to store catalog products
│      └── [product_id]           # Document ID = auto-generated or custom product ID
│               ├── name: "Sada (1981) Blu-ray" (String)
│               ├── Price: 20000 (double)
│               ├── imageUrl: "https://..../.jpg" (String)
│               └── Quantity: 37 (int64)
└── carts                         # Collection to store user shopping carts
       └── [user_uid]             # Document ID = Firebase Authentication UID (1:1 relation)
              └── items           # Field type: Map<String, int>
                    ├── "product_id_1": 2                    
                    └── "product_id_2": 2 
                    
                    # Map structure:
                    # key   = product ID (String)
                    # value = quantity (int)     
```

---

## 👤 Author

<p align="center">
Кошкин | йо: Кытин<br>
<a href="https://github.com/sochirishta">github.com/sochirishta</a>
</p>

---