import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  // Upload order selfie
  Future<String> uploadOrderSelfie(String orderId, File imageFile) async {
    try {
      final ref = _storage.ref().child('orders/$orderId/selfie.jpg');
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'orderId': orderId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload selfie: ${e.toString()}');
    }
  }

  // Upload user profile picture
  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('users/$userId/profile.jpg');
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'userId': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile picture: ${e.toString()}');
    }
  }

  // Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      throw Exception('Failed to pick image from camera: ${e.toString()}');
    }
  }

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      throw Exception('Failed to pick image from gallery: ${e.toString()}');
    }
  }

  // Show image picker options
  Future<File?> showImagePickerOptions() async {
    // This would typically show a dialog in the UI layer
    // For now, we'll default to camera
    return await pickImageFromCamera();
  }

  // Delete file from storage
  Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: ${e.toString()}');
    }
  }

  // Get file metadata
  Future<FullMetadata> getFileMetadata(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Failed to get file metadata: ${e.toString()}');
    }
  }
}

// Provider
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());
