import 'dart:convert';
import 'dart:typed_data';

import 'package:ardrive_eth_phase_2/signer.dart';
import 'package:cryptography/cryptography.dart';
import 'package:uuid/uuid.dart';

// ardrive-web/lib/services/crypto/crypto.dart
final sha256 = Sha256();

// ardrive-web/lib/services/crypto/keys.dart
const keyByteLength = 256 ~/ 8;
final hkdf = Hkdf(hmac: Hmac(sha256), outputLength: keyByteLength);

// ardrive-web/lib/services/crypto/keys.dart
// Changes: "Wallet" class substituted with "Signer" class
Future<SecretKey> deriveDriveKey(
  Signer wallet,
  String driveId,
  String password,
) async {
  final message =
      Uint8List.fromList(utf8.encode('drive') + Uuid.parse(driveId));
  final walletSignature = await wallet.sign(message);
  return hkdf.deriveKey(
    secretKey: SecretKey(walletSignature),
    info: utf8.encode(password),
    nonce: Uint8List(1),
  );
}