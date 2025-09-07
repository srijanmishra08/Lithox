import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class ContactService {
  /// Make a phone call with improved Android support
  static Future<void> makePhoneCall(String phoneNumber) async {
    // Clean the phone number (remove spaces, dashes, etc.)
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleanNumber,
    );
    
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(
          launchUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception('Could not launch phone dialer');
      }
    } catch (e) {
      throw Exception('Could not make phone call: $e');
    }
  }

  /// Open WhatsApp with improved Android support
  static Future<void> openWhatsApp(String phoneNumber, {String? message}) async {
    // Clean the phone number (remove spaces, dashes, etc.)
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Try different WhatsApp approaches for better Android compatibility
    final approaches = [
      // 1. Try native WhatsApp intent for Android
      if (Platform.isAndroid) _createWhatsAppIntent(cleanNumber, message),
      
      // 2. Try wa.me URL
      _createWhatsAppWebUrl(cleanNumber, message),
      
      // 3. Try direct WhatsApp URL scheme
      _createWhatsAppDirectUrl(cleanNumber, message),
    ];

    for (final uri in approaches) {
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          return; // Success, exit
        }
      } catch (e) {
        // Continue to next approach
        continue;
      }
    }
    
    throw Exception('WhatsApp is not installed or could not be opened');
  }

  /// Create WhatsApp intent URI for Android
  static Uri _createWhatsAppIntent(String phoneNumber, String? message) {
    final encodedMessage = message != null ? Uri.encodeComponent(message) : '';
    return Uri.parse('whatsapp://send?phone=$phoneNumber&text=$encodedMessage');
  }

  /// Create wa.me URL for web fallback
  static Uri _createWhatsAppWebUrl(String phoneNumber, String? message) {
    return Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phoneNumber,
      queryParameters: message != null ? {'text': message} : null,
    );
  }

  /// Create direct WhatsApp URL scheme
  static Uri _createWhatsAppDirectUrl(String phoneNumber, String? message) {
    final query = message != null ? 'text=${Uri.encodeComponent(message)}' : '';
    return Uri.parse('https://api.whatsapp.com/send?phone=$phoneNumber&$query');
  }

  /// Check if WhatsApp is installed (Android specific)
  static Future<bool> isWhatsAppInstalled() async {
    try {
      final uri = Uri.parse('whatsapp://send');
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  /// Check if phone dialer is available
  static Future<bool> isPhoneDialerAvailable() async {
    try {
      final uri = Uri(scheme: 'tel', path: '');
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }
}
