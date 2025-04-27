import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class EncryptHelper {
  static String encryptString(String jsonString, String password) {
    final key = Key.fromUtf8(_generateKey(password));
    final iv = IV.fromLength(16);
    final encrypt = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypt.encrypt(jsonString, iv: iv);
    return base64Encode(iv.bytes + encrypted.bytes);
  }

  static String decryptString(String encryptedData, String password) {
    final decoded = base64Decode(encryptedData);
    final iv = IV(Uint8List.fromList(decoded.sublist(0, 16)));
    final encryptedBytes = decoded.sublist(16);

    final key = Key.fromUtf8(_generateKey(password));
    final encrypted = Encrypter(AES(key, mode: AESMode.cbc));

    final decrypted = encrypted.decrypt(Encrypted(Uint8List.fromList(encryptedBytes)), iv: iv);
    return decrypted;
  }

  static String _generateKey(String password) {
    return sha256.convert(utf8.encode(password)).toString().substring(0, 32);
  }

  static void testPrint() {
    print('Hello world');
  }
}
