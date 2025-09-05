# Lithox Epoxy App

A Flutter mobile application for Lithox epoxy flooring service booking. Customers can browse services, place orders with selfie verification, and track their order progress in real-time.

## Features

- **Authentication**: Email/password login and registration
- **Service Catalog**: Browse available epoxy flooring services
- **Order Booking**: Multi-step booking form with selfie upload
- **Real-time Tracking**: Live order status updates
- **Security**: Client-side encryption for sensitive data
- **Admin Notifications**: Email alerts for new orders

## Tech Stack

- **Framework**: Flutter 3.16+
- **State Management**: Riverpod 2.4+
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Security**: AES encryption with Flutter Secure Storage
- **Navigation**: GoRouter

## Prerequisites

Before you begin, ensure you have:

- Flutter SDK 3.16+ installed
- Android Studio or VS Code with Flutter extensions
- Firebase account
- Git

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `lithox-epoxy-app`
4. Enable Google Analytics (optional)
5. Create project

### 2. Enable Firebase Services

In your Firebase project console:

1. **Authentication**:
   - Go to Authentication > Sign-in method
   - Enable "Email/Password"

2. **Firestore Database**:
   - Go to Firestore Database
   - Create database in production mode
   - Choose your region

3. **Storage**:
   - Go to Storage
   - Get started with default rules

### 3. Add Android App

1. In Firebase console, click "Add app" > Android
2. Register app with these details:
   - **Android package name**: `com.lithox.epoxy.lithox_epoxy_app`
   - **App nickname**: `Lithox Epoxy App`
   - **Debug signing certificate SHA-1**: (See below)

### 4. Generate SHA-1 Certificate

Run this command in your project directory:

```bash
# For debug certificate (development)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Copy the SHA-1 fingerprint and paste it in Firebase console
```

### 5. Download google-services.json

1. Download the `google-services.json` file from Firebase console
2. Place it in: `android/app/google-services.json`

⚠️ **Important**: The `google-services.json` file is already gitignored for security.

### 6. Update Android Configuration

The following files are already configured in this project:

- `android/app/build.gradle` - Firebase dependencies
- `android/build.gradle` - Google services plugin
- `android/app/src/main/AndroidManifest.xml` - Permissions

### 7. Firestore Security Rules

Add these security rules in Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can read/write their own orders
    match /orders/{orderId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow create: if request.auth != null;
    }
    
    // Anyone can read services (public catalog)
    match /services/{serviceId} {
      allow read: if true;
      allow write: if request.auth != null && 
        request.auth.token.admin == true;
    }
  }
}
```

## Installation & Setup

### 1. Clone Repository

```bash
git clone <repository-url>
cd lithox-epoxy-app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Environment Variables

```bash
# Copy environment file
cp .env.example .env

# Edit .env with your values
nano .env
```

### 4. Add google-services.json

Place your `google-services.json` file in `android/app/`

### 5. Seed Services Data

The app will automatically seed sample services data on first run. You can also manually add services through the Firebase console.

### 6. Run the App

```bash
# Run in debug mode
flutter run

# Or run for Android specifically
flutter run -d android
```

## Build for Production

### 1. Generate Keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Create key.properties

Create `android/key.properties`:

```properties
storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=upload
storeFile=<location-of-the-keystore-file>
```

### 3. Build Release APK

```bash
flutter build apk --release
```

### 4. Build App Bundle

```bash
flutter build appbundle --release
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── order.dart
│   └── service.dart
├── screens/                  # UI screens
│   ├── auth/
│   ├── home_screen.dart
│   ├── services/
│   ├── booking/
│   ├── tracking/
│   └── profile/
├── services/                 # Business logic
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── storage_service.dart
│   ├── encryption_service.dart
│   └── email_service_stub.dart
└── widgets/                  # Reusable components
```

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `SENDGRID_API_KEY` | SendGrid API key for emails | No |
| `ADMIN_EMAIL` | Admin email for notifications | Yes |
| `FIREBASE_PROJECT_ID` | Firebase project ID | No* |

*Firebase config is handled by `google-services.json`

## Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## Deployment

### Cloud Functions (Optional)

For email notifications, deploy the Cloud Function:

```bash
cd functions
npm install
npm run deploy
```

## Security Notes

- Sensitive data (address, phone) is encrypted client-side
- Encryption keys are stored in Flutter Secure Storage
- Firebase Security Rules protect user data
- Never commit `google-services.json` to version control

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, email support@lithox.com or create an issue in this repository.

---

**Chemistry for Stones** - Lithox Epoxy Services
