import 'package:url_launcher/url_launcher.dart';
import '../utils/app_constants.dart';

class SimpleEmailService {
  /// Opens device email client with pre-filled booking details
  /// User just needs to press send
  static Future<bool> openEmailWithBookingDetails({
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
      // Generate unique order ID for tracking
      final orderId = 'LTX-${DateTime.now().millisecondsSinceEpoch}';
      final formattedDate = DateTime.now().toString().split('.')[0];
      
      // Create professional email subject
      final subject = '🔥 NEW Epoxy Consultation Request - $name (ID: ${orderId.substring(4, 12)})';
      
      // Create comprehensive email body with all details
      final emailBody = '''
🏢 LITHOX EPOXY - NEW CONSULTATION REQUEST
═══════════════════════════════════════════════════════════════

📋 ORDER INFORMATION:
   • Order ID: $orderId
   • Submitted: $formattedDate
   • Source: Mobile App

👤 CUSTOMER DETAILS:
   • Name: $name
   • Email: $email
   • Phone: $phone

📍 PROJECT LOCATION:
   • Address: $address
   • City: $city${area.isNotEmpty ? '\n   • Area/Locality: $area' : ''}

🔧 SERVICE REQUIREMENTS:
   • Service Type: $serviceType
   • Approximate Area: ${approximateArea.isNotEmpty ? approximateArea : 'Not specified'}
   • Photos Included: $photoCount photo${photoCount == 1 ? '' : 's'}

📝 ADDITIONAL NOTES:
${notes.isNotEmpty ? notes : 'No additional requirements specified.'}

═══════════════════════════════════════════════════════════════
⚡ URGENT: Please contact customer within 24 hours
📱 This request was submitted through Lithox Epoxy Mobile App
═══════════════════════════════════════════════════════════════

Best regards,
Lithox Epoxy Automated Booking System
      ''';

      // Create mailto URL with encoded parameters
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: AppConstants.businessEmail,
        query: _encodeQueryParameters({
          'subject': subject,
          'body': emailBody,
        }),
      );

      // DEBUG: print statement commented out for production
      // DEBUG: print statement commented out for production
      // DEBUG: print statement commented out for production
      // Try to launch the email client
      if (await canLaunchUrl(emailUri)) {
        final launched = await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
        
        if (launched) {
          // DEBUG: print statement commented out for production
          return true;
        } else {
          // DEBUG: print statement commented out for production
          return false;
        }
      } else {
        // DEBUG: print statement commented out for production
        return false;
      }
    } catch (e) {
      // DEBUG: print statement commented out for production
      return false;
    }
  }

  /// Alternative method that creates a shorter, more focused email
  static Future<bool> openQuickEmail({
    required String name,
    required String email,
    required String phone,
    required String serviceType,
    required String city,
  }) async {
    try {
      final orderId = 'LTX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      
      final subject = 'Quick Consultation Request - $name';
      
      final emailBody = '''
Hi Lithox Team,

I'm interested in your epoxy flooring services.

Customer: $name
Email: $email  
Phone: $phone
Service: $serviceType
Location: $city
Order ID: $orderId

Please contact me for a consultation.

Thanks!
      ''';

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: AppConstants.businessEmail,
        query: _encodeQueryParameters({
          'subject': subject,
          'body': emailBody,
        }),
      );

      if (await canLaunchUrl(emailUri)) {
        return await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
      }
      
      return false;
    } catch (e) {
      // DEBUG: print statement commented out for production
      return false;
    }
  }

  /// Encode query parameters for URL
  static String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}