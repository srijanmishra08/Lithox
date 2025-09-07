import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'contact_service.dart';

/// Debug utility for testing contact functionality
class ContactDebugHelper {
  /// Test phone call functionality with detailed logging
  static Future<void> testPhoneCall(BuildContext context, String phoneNumber) async {
    if (kDebugMode) {
      print('🔍 Testing phone call to: $phoneNumber');
    }
    
    try {
      // Check if phone dialer is available
      final isAvailable = await ContactService.isPhoneDialerAvailable();
      if (kDebugMode) {
        print('📱 Phone dialer available: $isAvailable');
      }
      
      if (!isAvailable) {
        _showDebugMessage(context, 'Phone dialer not available on this device', isError: true);
        return;
      }
      
      await ContactService.makePhoneCall(phoneNumber);
      _showDebugMessage(context, 'Phone call initiated successfully');
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ Phone call error: $e');
      }
      _showDebugMessage(context, 'Phone call failed: ${e.toString().replaceAll('Exception: ', '')}', isError: true);
    }
  }

  /// Test WhatsApp functionality with detailed logging
  static Future<void> testWhatsApp(BuildContext context, String phoneNumber, {String? message}) async {
    if (kDebugMode) {
      print('🔍 Testing WhatsApp to: $phoneNumber');
      print('💬 Message: ${message ?? 'No message'}');
    }
    
    try {
      // Check if WhatsApp is installed
      final isInstalled = await ContactService.isWhatsAppInstalled();
      if (kDebugMode) {
        print('📱 WhatsApp installed: $isInstalled');
      }
      
      await ContactService.openWhatsApp(phoneNumber, message: message);
      _showDebugMessage(context, 'WhatsApp opened successfully');
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ WhatsApp error: $e');
      }
      _showDebugMessage(context, 'WhatsApp failed: ${e.toString().replaceAll('Exception: ', '')}', isError: true);
    }
  }

  /// Show debug message to user
  static void _showDebugMessage(BuildContext context, String message, {bool isError = false}) {
    if (kDebugMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  /// Show contact options dialog with debug info
  static void showContactDebugDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Debug'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Test contact functionality:'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      testPhoneCall(context, '+919057263521');
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Test Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      testWhatsApp(
                        context, 
                        '+919057263521',
                        message: 'Hi, I am testing the Lithox app contact functionality.',
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Test WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
