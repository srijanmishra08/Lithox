import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class EmailService {
  // EmailJS configuration - You need to set these up at https://emailjs.com
  static const String _serviceId = 'your_service_id';
  static const String _templateId = 'your_template_id';
  static const String _publicKey = 'your_public_key';

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
      // Try to send via EmailJS first
      final emailJSSuccess = await _sendViaEmailJS(
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

      if (emailJSSuccess) {
        return true;
      } else {
        // Fallback to mailto if EmailJS fails
        return await _sendViaMailto(
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
      }
    } catch (e) {
      // Fallback to mailto on error
      return await _sendViaMailto(
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
    }
  }

  static Future<bool> _sendViaEmailJS({
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
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'customer_name': name,
            'customer_email': email,
            'customer_phone': phone,
            'customer_address': address,
            'customer_city': city,
            'customer_area': area.isNotEmpty ? area : 'Not specified',
            'service_type': serviceType,
            'approximate_area': approximateArea,
            'additional_notes': notes.isNotEmpty ? notes : 'None',
            'photo_count': photoCount.toString(),
            'submission_date': DateTime.now().toString(),
            'to_email': 'Srijanmishram@gmail.com',
          },
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('EmailJS error: $e');
      return false;
    }
  }

  static Future<bool> _sendViaMailto({
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

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        return true;
      }
      return false;
    } catch (e) {
      return false;
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
