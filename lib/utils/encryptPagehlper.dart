import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class CryptoHelper {
  static const String secretKey = "role-secret-key";

  static String encryptUrl(String value) {
    final salt = Uint8List.fromList([74, 84, 50, 27, 22, 193, 115, 181]);

    final keyIv = _deriveKeyAndIv(secretKey, salt);
    final key = encrypt.Key(keyIv.item1);
    final iv = encrypt.IV(keyIv.item2);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    final encrypted = encrypter.encrypt(value, iv: iv);

    final saltedPrefix = utf8.encode("Salted__");
    final combined = Uint8List.fromList(saltedPrefix + salt + encrypted.bytes);

    final base64Result = base64Encode(combined);

    return base64Result
        .replaceAll('+', '-')
        .replaceAll('/', '_')
        .replaceAll('=', '');
  }
  static dynamic decryptUrl(String input) {
    try {
      // Convert Base64URL back to Base64
      String base64Input = input.replaceAll('-', '+').replaceAll('_', '/');

      while (base64Input.length % 4 != 0) {
        base64Input += '=';
      }

      final bytes = base64Decode(base64Input);

      final salt = Uint8List.fromList(bytes.sublist(8, 16));
      final ciphertext = Uint8List.fromList(bytes.sublist(16));

      final keyIv = _deriveKeyAndIv(secretKey, salt);
      final key = encrypt.Key(keyIv.item1);
      final iv = encrypt.IV(keyIv.item2);

      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );

      final decrypted = encrypter.decrypt(
        encrypt.Encrypted(ciphertext),
        iv: iv,
      );

      return jsonDecode(decrypted);
    } catch (e) {
      return null;
    }
  }

  static Tuple2<Uint8List, Uint8List> _deriveKeyAndIv(
    String password,
    Uint8List salt,
  ) {
    final passwordBytes = utf8.encode(password);
    const keyLength = 32;
    const ivLength = 16;

    final derived = <int>[];
    List<int> block = [];

    while (derived.length < keyLength + ivLength) {
      final digest = md5.convert([...block, ...passwordBytes, ...salt]);
      block = digest.bytes;
      derived.addAll(block);
    }

    final key = Uint8List.fromList(derived.sublist(0, keyLength));
    final iv = Uint8List.fromList(
      derived.sublist(keyLength, keyLength + ivLength),
    );

    return Tuple2(key, iv);
  }
}

class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;
  Tuple2(this.item1, this.item2);
}
