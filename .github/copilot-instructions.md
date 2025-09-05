<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Lithox Epoxy App - Copilot Instructions

## Project Overview
This is a Flutter mobile application for Lithox epoxy flooring service booking. The app allows customers to browse services, place orders, upload selfies for verification, and track order progress.

## Architecture & Tech Stack
- **Framework**: Flutter 3.16+ with Dart 3.0+
- **State Management**: Riverpod 2.4+
- **Architecture**: Clean Architecture + MVVM pattern
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Security**: Client-side encryption for sensitive data
- **Navigation**: GoRouter

## Key Features
1. Email/Password authentication with Firebase Auth
2. Service catalog with Firestore integration
3. Order booking with selfie upload to Firebase Storage
4. Real-time order tracking
5. Client-side encryption for sensitive fields (address, phone)
6. Email notifications via Cloud Functions

## Code Standards
- Use Material 3 design system
- Follow Flutter best practices
- Implement proper error handling and loading states
- Use Riverpod for state management
- Apply client-side encryption for sensitive data
- Include proper validation for all forms
- Use responsive design principles

## File Structure
```
lib/
├── main.dart
├── models/ (User, Order, Service)
├── screens/ (auth, home, services, booking, tracking, profile)
├── services/ (auth, firestore, storage, encryption, email)
└── widgets/ (reusable UI components)
```

## Security Considerations
- Encrypt sensitive data (address, phone) before storing in Firestore
- Use Firebase Security Rules to protect user data
- Store encryption keys in Flutter Secure Storage
- Validate all user inputs
- Use HTTPS for all network requests

## Firebase Integration
- Authentication: Email/password with user profile storage
- Firestore: Orders, services, and user data
- Storage: Selfie images and profile pictures
- Cloud Functions: Email notifications on order creation

When writing code, prioritize security, user experience, and maintainability.
