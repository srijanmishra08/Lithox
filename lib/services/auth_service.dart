import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  // Auth state changes stream
  Stream<firebase_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Register with email and password
  Future<User> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Failed to create user account');
      }

      // Update display name
      await credential.user!.updateDisplayName(name);

      // Create user document in Firestore
      final user = User(
        uid: credential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Sign in with email and password
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Failed to sign in');
      }

      // Get user document from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User profile not found');
      }

      return User.fromJson(userDoc.data()!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Get current user profile
  Future<User?> getCurrentUserProfile() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return null;

    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) return null;

      return User.fromJson(userDoc.data()!);
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(User user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update(user.toJson());
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  String _handleFirebaseAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      default:
        return 'An authentication error occurred: ${e.message}';
    }
  }
}

// Providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<firebase_auth.User?>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

final currentUserProvider = FutureProvider<User?>((ref) {
  return ref.read(authServiceProvider).getCurrentUserProfile();
});
