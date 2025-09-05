import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EncryptionService {
  static const String _keyStorageKey = 'lithox_encryption_key';
  static const _secureStorage = FlutterSecureStorage();
  
  Encrypter? _encrypter;
  IV? _iv;

  // Initialize encryption service
  Future<void> initialize() async {
    final key = await _getOrCreateKey();
    _encrypter = Encrypter(AES(key));
    _iv = IV.fromSecureRandom(16);
  }

  // Get or create encryption key
  Future<Key> _getOrCreateKey() async {
    try {
      final storedKey = await _secureStorage.read(key: _keyStorageKey);
      
      if (storedKey != null) {
        // Use existing key
        return Key.fromBase64(storedKey);
      } else {
        // Generate new key
        final key = Key.fromSecureRandom(32);
        await _secureStorage.write(key: _keyStorageKey, value: key.base64);
        return key;
      }
    } catch (e) {
      throw Exception('Failed to get or create encryption key: ${e.toString()}');
    }
  }

  // Encrypt text
  Future<String> encryptText(String plainText) async {
    if (_encrypter == null) {
      await initialize();
    }

    try {
      final iv = IV.fromSecureRandom(16);
      final encrypted = _encrypter!.encrypt(plainText, iv: iv);
      
      // Combine IV and encrypted data
      final combined = iv.base64 + ':' + encrypted.base64;
      return base64Encode(utf8.encode(combined));
    } catch (e) {
      throw Exception('Failed to encrypt text: ${e.toString()}');
    }
  }

  // Decrypt text
  Future<String> decryptText(String encryptedText) async {
    if (_encrypter == null) {
      await initialize();
    }

    try {
      // Decode the base64 encoded string
      final combined = utf8.decode(base64Decode(encryptedText));
      final parts = combined.split(':');
      
      if (parts.length != 2) {
        throw Exception('Invalid encrypted data format');
      }

      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      
      return _encrypter!.decrypt(encrypted, iv: iv);
    } catch (e) {
      throw Exception('Failed to decrypt text: ${e.toString()}');
    }
  }

  // Generate a random key (for testing or key rotation)
  String generateRandomKey() {
    final key = Key.fromSecureRandom(32);
    return key.base64;
  }

  // Check if encryption key exists
  Future<bool> hasEncryptionKey() async {
    try {
      final storedKey = await _secureStorage.read(key: _keyStorageKey);
      return storedKey != null;
    } catch (e) {
      return false;
    }
  }

  // Reset encryption key (WARNING: This will make existing encrypted data unreadable)
  Future<void> resetEncryptionKey() async {
    try {
      await _secureStorage.delete(key: _keyStorageKey);
      _encrypter = null;
      _iv = null;
    } catch (e) {
      throw Exception('Failed to reset encryption key: ${e.toString()}');
    }
  }

  // Encrypt sensitive user data
  Future<Map<String, String>> encryptUserSensitiveData({
    String? address,
    String? phone,
  }) async {
    final result = <String, String>{};
    
    if (address != null && address.isNotEmpty) {
      result['address_encrypted'] = await encryptText(address);
    }
    
    if (phone != null && phone.isNotEmpty) {
      result['phone_encrypted'] = await encryptText(phone);
    }
    
    return result;
  }

  // Decrypt sensitive user data
  Future<Map<String, String>> decryptUserSensitiveData({
    String? encryptedAddress,
    String? encryptedPhone,
  }) async {
    final result = <String, String>{};
    
    if (encryptedAddress != null && encryptedAddress.isNotEmpty) {
      try {
        result['address'] = await decryptText(encryptedAddress);
      } catch (e) {
        result['address'] = 'Decryption failed';
      }
    }
    
    if (encryptedPhone != null && encryptedPhone.isNotEmpty) {
      try {
        result['phone'] = await decryptText(encryptedPhone);
      } catch (e) {
        result['phone'] = 'Decryption failed';
      }
    }
    
    return result;
  }
}

// Provider
final encryptionServiceProvider = Provider<EncryptionService>((ref) => EncryptionService());
