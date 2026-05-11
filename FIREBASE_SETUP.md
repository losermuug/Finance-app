# Firebase setup

The app is wired to Cloud Firestore through `FinanceRepository`.

Firestore collection:

- `transactions`

Document fields:

- `title`: string
- `subtitle`: string
- `amountCents`: number, positive for income and negative for expense
- `iconKey`: string
- `paymentMethod`: string or null
- `createdAt`: timestamp

To connect a real Firebase project:

1. Install and sign in to the Firebase CLI.
2. Install FlutterFire CLI.
3. Run from this project root:

```sh
flutterfire configure
```

That command creates the official Firebase config for your project. This app
also supports runtime config via dart defines:

```sh
flutter run \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_PROJECT_ID=...
```

If no Firebase config is provided, the app runs with an in-memory fallback so UI
development and tests still work.
