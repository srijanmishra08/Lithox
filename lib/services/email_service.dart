import 'package:url_launcher/url_launcher.dart';

class EmailService {
  static Future<void> sendBookingEmail({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String area,
    required String serviceType,
    required String approximateArea,
    required String notes,
    required bool hasPhoto,
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

${hasPhoto ? 'Photo attached: Yes' : 'Photo attached: No'}

Submitted on: ${DateTime.now().toString()}

---
This request was submitted through the Lithox Epoxy mobile app.
Please contact the customer within 24 hours.
    ''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'srijanmishram@gmail.com',
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
