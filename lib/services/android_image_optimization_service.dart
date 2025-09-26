import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_constants.dart';

/// Android-optimized image handling service
/// Provides optimized image picking and processing for Android devices
class AndroidImageOptimizationService {
  static final ImagePicker _picker = ImagePicker();

  /// Pick image from camera with Android optimizations
  static Future<XFile?> pickImageFromCamera({
    double? maxWidth = AppConstants.maxImageWidth,
    double? maxHeight = AppConstants.maxImageHeight,
    int imageQuality = AppConstants.imageQuality,
  }) async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        // Android-specific optimizations
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
          preferredCameraDevice: CameraDevice.rear,
        );
        return image;
      } else {
        // Fallback for other platforms
        return await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );
      }
    } catch (e) {
      debugPrint('AndroidImageOptimizationService: Error picking camera image: $e');
      return null;
    }
  }

  /// Pick image from gallery with Android optimizations
  static Future<XFile?> pickImageFromGallery({
    double? maxWidth = AppConstants.maxImageWidth,
    double? maxHeight = AppConstants.maxImageHeight,
    int imageQuality = AppConstants.imageQuality,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
      return image;
    } catch (e) {
      debugPrint('AndroidImageOptimizationService: Error picking gallery image: $e');
      return null;
    }
  }

  /// Pick multiple images with Android optimizations
  static Future<List<XFile>?> pickMultipleImages({
    double? maxWidth = AppConstants.maxImageWidth,
    double? maxHeight = AppConstants.maxImageHeight,
    int imageQuality = AppConstants.imageQuality,
    int? limit = AppConstants.maxImagesPerForm,
  }) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        limit: limit,
      );
      return images;
    } catch (e) {
      debugPrint('AndroidImageOptimizationService: Error picking multiple images: $e');
      return null;
    }
  }

  /// Show image picker dialog optimized for Android
  static Future<XFile?> showImagePickerDialog(BuildContext context) async {
    return showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Select Image',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPickerOption(
                              context: context,
                              icon: Icons.camera_alt,
                              label: 'Camera',
                              onTap: () async {
                                Navigator.pop(context);
                                await pickImageFromCamera();
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPickerOption(
                              context: context,
                              icon: Icons.photo_library,
                              label: 'Gallery',
                              onTap: () async {
                                Navigator.pop(context);
                                await pickImageFromGallery();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildPickerOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get image file size in MB
  static Future<double> getImageFileSizeInMB(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.length();
      return bytes / (1024 * 1024); // Convert to MB
    } catch (e) {
      debugPrint('AndroidImageOptimizationService: Error getting file size: $e');
      return 0;
    }
  }

  /// Check if image is within size limits for Android
  static Future<bool> isImageSizeValid(String filePath, {double maxSizeInMB = AppConstants.maxImageSizeInMB}) async {
    final sizeInMB = await getImageFileSizeInMB(filePath);
    return sizeInMB <= maxSizeInMB;
  }
}
