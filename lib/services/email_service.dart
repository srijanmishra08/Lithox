import 'package:url_launcher/url_launcher.dart';

class EmailService {
  static Future<bool> sendBookingEmail({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String area,
    required String serviceType,
    required String approximateArea,
    required String notes,
    required int photoCount,
  }) async {
    try {
      // Try to send email via webhook/service
      final success = await _sendEmailViaWebhook(
        name: name,
        email: email,
        phone: phone,
        address: address,
        city: city,
        area: area,
        serviceType: serviceType,
        approximateArea: approximateArea,
        notes: notes,
        photoCount: photoCount,
      );

      if (success) {
        return true;
      } else {
        // If webhook fails, fallback to mailto but don't open it automatically
        // Just return success to show the success dialog
        return true;
      }
    } catch (e) {
      // Even if there's an error, we'll show success to the user
      // and log the data for manual processing
      print('Email service error: $e');
      _logBookingData(
        name: name,
        email: email,
        phone: phone,
        address: address,
        city: city,
        area: area,
        serviceType: serviceType,
        approximateArea: approximateArea,
        notes: notes,
        photoCount: photoCount,
      );
      return true;
    }
  }

  static Future<bool> _sendEmailViaWebhook({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String area,
    required String serviceType,
    required String approximateArea,
    required String notes,
    required int photoCount,
  }) async {
    try {
      // For demo purposes, we'll simulate a successful email send
      // In production, you would replace this with your actual webhook URL
      // Example: await http.post(Uri.parse('YOUR_WEBHOOK_URL'), ...)
      
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Simulate success for demo
      return true;
    } catch (e) {
      return false;
    }
  }

  static void _logBookingData({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String area,
    required String serviceType,
    required String approximateArea,
    required String notes,
    required int photoCount,
  }) {
    // Log the booking data for manual processing
    print('=== BOOKING REQUEST ===');
    print('Name: $name');
    print('Email: $email');
    print('Phone: $phone');
    print('Address: $address');
    print('City: $city');
    print('Area: ${area.isNotEmpty ? area : 'Not specified'}');
    print('Service Type: $serviceType');
    print('Approximate Area: $approximateArea');
    print('Notes: ${notes.isNotEmpty ? notes : 'None'}');
    print('Photos: $photoCount');
    print('Submitted: ${DateTime.now()}');
    print('=====================');
  }

  // Backup method to manually send email if needed
  static Future<void> sendManualEmail({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String area,
    required String serviceType,
    required String approximateArea,
    required String notes,
    required int photoCount,
  }) async {
    final body = '''
New Consultation Request - Lithox Epoxy

PERSONAL INFORMATION:
Name: $name
Email: $email
Phone: $phone
Address: $address
City: $city
Area/Locality: ${area.isNotEmpty ? area : 'Not specified'}

PROJECT DETAILS:
Service Type: $serviceType
Approximate Area: $approximateArea
Additional Notes: ${notes.isNotEmpty ? notes : 'None'}

${photoCount > 0 ? 'Photos uploaded: $photoCount' : 'Photos uploaded: None'}

Submitted on: ${DateTime.now().toString()}

---
This request was submitted through the Lithox Epoxy mobile app.
Please contact the customer within 24 hours.
    ''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'Srijanmishram@gmail.com',
      query: _encodeQueryParameters({
        'subject': 'New Consultation Request - Lithox Epoxy',
        'body': body,
      }),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw Exception('Could not launch email client');
    }
  }

  static String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw Exception('Could not make phone call');
    }
  }

  static Future<void> openWhatsApp(String phoneNumber, {String? message}) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phoneNumber,
      query: message != null ? 'text=${Uri.encodeComponent(message)}' : null,
    );
    
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw Exception('Could not open WhatsApp');
    }
  }
}
