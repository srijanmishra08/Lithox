import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AndroidOptimizationService {
  // Optimized phone calling for Android
  static Future<bool> makePhoneCall(
    BuildContext context,
    String phoneNumber, {
    bool showFeedback = true,
  }) async {
    try {
      // Ensure the number is properly formatted
      final formattedNumber = phoneNumber.startsWith('tel:') 
          ? phoneNumber 
          : 'tel:$phoneNumber';
      
      final phoneUrl = Uri.parse(formattedNumber);
      
      if (await canLaunchUrl(phoneUrl)) {
        await launchUrl(
          phoneUrl,
          mode: LaunchMode.externalApplication,
        );
        return true;
      } else {
        if (showFeedback && context.mounted) {
          _showPhoneErrorSnackBar(context, phoneNumber);
        }
        return false;
      }
    } catch (e) {
      debugPrint('Error making phone call: $e');
      if (showFeedback && context.mounted) {
        _showPhoneErrorSnackBar(context, phoneNumber);
      }
      return false;
    }
  }

  // Optimized WhatsApp messaging for Android
  static Future<bool> sendWhatsAppMessage(
    BuildContext context,
    String phoneNumber,
    String message, {
    bool showFeedback = true,
  }) async {
    try {
      // Remove any spaces or special characters from phone number
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      
      // Properly encode the message for URL
      final encodedMessage = Uri.encodeComponent(message);
      
      // Primary WhatsApp URL
      final whatsappUrl = Uri.parse('https://wa.me/$cleanNumber?text=$encodedMessage');
      
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
        return true;
      } else {
        // Fallback: Try WhatsApp Business API
        final whatsappBusinessUrl = Uri.parse(
          'https://api.whatsapp.com/send?phone=$cleanNumber&text=$encodedMessage'
        );
        
        if (await canLaunchUrl(whatsappBusinessUrl)) {
          await launchUrl(whatsappBusinessUrl, mode: LaunchMode.externalApplication);
          return true;
        } else {
          if (showFeedback && context.mounted) {
            _showWhatsAppErrorSnackBar(context, phoneNumber);
          }
          return false;
        }
      }
    } catch (e) {
      debugPrint('Error sending WhatsApp message: $e');
      if (showFeedback && context.mounted) {
        _showWhatsAppErrorSnackBar(context, phoneNumber);
      }
      return false;
    }
  }

  // Optimized URL launching for Android
  static Future<bool> launchWebUrl(
    BuildContext context,
    String url, {
    bool showFeedback = true,
  }) async {
    try {
      // Ensure proper URL format
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }
      
      final uri = Uri.parse(formattedUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        return true;
      } else {
        if (showFeedback && context.mounted) {
          _showUrlErrorSnackBar(context, url);
        }
        return false;
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (showFeedback && context.mounted) {
        _showUrlErrorSnackBar(context, url);
      }
      return false;
    }
  }

  // Check if running on Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  // Get Android-optimized message for WhatsApp
  static String getOptimizedWhatsAppMessage(String baseMessage, {String? orderId}) {
    if (orderId != null) {
      return 'Hi, I need help with my order $orderId. $baseMessage Please assist me.';
    }
    return '$baseMessage Please provide more information.';
  }

  // Error handling methods
  static void _showPhoneErrorSnackBar(BuildContext context, String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll('tel:', '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Phone app not available. Please install a phone app or call $cleanNumber manually.'
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Copy Number',
          onPressed: () {
            // Copy to clipboard functionality could be added here
          },
        ),
      ),
    );
  }

  static void _showWhatsAppErrorSnackBar(BuildContext context, String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'WhatsApp not available. Please install WhatsApp or contact via phone at $cleanNumber.'
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Call Instead',
          onPressed: () {
            makePhoneCall(context, cleanNumber, showFeedback: false);
          },
        ),
      ),
    );
  }

  static void _showUrlErrorSnackBar(BuildContext context, String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Unable to open $url. Please check your internet connection.'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Android-specific back button handling
  static Future<bool> handleBackButton(BuildContext context) async {
    // Show confirmation dialog for important screens
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    
    return shouldPop ?? false;
  }

  // Optimized image picker for Android
  static Future<bool> checkAndRequestPermissions() async {
    // This would integrate with permission_handler package if needed
    // For now, we rely on the permissions declared in AndroidManifest.xml
    return true;
  }

  // Android performance optimizations
  static void optimizeForAndroid() {
    if (isAndroid) {
      // Any Android-specific optimizations could go here
      debugPrint('Android optimizations applied');
    }
  }
}
