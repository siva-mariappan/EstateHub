# ⚡ Quick Setup Commands

## Run these commands in order:

### 1. Install Firebase CLI
```bash
npm install -g firebase-tools
```

### 2. Login to Firebase
```bash
firebase login
```

### 3. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 4. Navigate to project
```bash
cd "/Users/sivam/Downloads/realestate/My Realetate project/realestate_app"
```

### 5. Configure Firebase
```bash
flutterfire configure
```
- Select your Firebase project (or create new one)
- Select platforms: Android, iOS, Web
- This generates `firebase_options.dart` automatically

### 6. Install dependencies
```bash
flutter pub get
```

### 7. Get Android SHA-1 (for Android testing)
```bash
cd android
./gradlew signingReport
cd ..
```
Copy the SHA-1 and add it to Firebase Console > Project Settings > Your Android App

### 8. Run the app
```bash
flutter run
```

---

## Firebase Console Steps:

1. Go to https://console.firebase.google.com/
2. Select your project
3. Click **Authentication** → **Sign-in method**
4. Enable **Google**
5. Add support email
6. Save
7. (Android only) Add SHA-1 fingerprint in Project Settings

---

## That's it! Your app should now have working Google Sign-In! 🎉
