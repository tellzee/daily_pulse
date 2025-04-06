# Daily Pulse

A personal journal and app usage tracking application built with Flutter.

## Features

- **Journal Entries**
  - Write and manage daily journal entries
  - Add mood and tags to entries
  - Cloud sync for data backup
  - Offline support

- **App Usage Tracking**
  - Track app usage time
  - View top 10 most used apps
  - Visual statistics with charts
  - Daily and weekly usage patterns

## Setup Instructions

1. **Prerequisites**
   - Flutter SDK (latest version)
   - Android Studio / VS Code
   - Git

2. **Installation**
   ```bash
   # Clone the repository
   git clone [repository-url]

   # Navigate to project directory
   cd daily_pulse

   # Install dependencies
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication and Firestore
   - Add Android and iOS apps to your Firebase project
   - Download and add the configuration files:
     - Android: `google-services.json` to `android/app/`
     - iOS: `GoogleService-Info.plist` to `ios/Runner/`

4. **Android Permissions**
   Add the following permissions to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" />
   ```

5. **Run the App**
   ```bash
   flutter run
   ```

## Usage

1. **Journal**
   - Tap the "+" button to add a new entry
   - Swipe left on an entry to delete it
   - Tap an entry to view details

2. **App Usage**
   - Grant usage access permission when prompted
   - View your top 10 most used apps
   - Check usage time in hours and minutes
   - Pull down to refresh statistics

## Notes

- App usage tracking requires special permissions on Android
- Some features might be limited on iOS due to platform restrictions
- Data is synced to Firebase for backup and cross-device access

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License. 