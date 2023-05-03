import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ardrive_eth_phase_2/kdf.dart';
import 'package:convert/convert.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

abstract class Signer {
  FutureOr<Uint8List> sign(Uint8List data, [String password]);
}

class EthWalletConnectSigner implements Signer {
  final WalletConnect connector;
  final String address;

  EthWalletConnectSigner(this.connector, this.address);

  @override
  Future<Uint8List> sign(Uint8List data, [String? password]) async {
    final provider = EthereumWalletConnectProvider(connector);
    final message = '0x${hex.encode(data)}';
    print('message: $message');
    final signature = await provider.personalSign(
      message: message,
      address: address,
      password: password ?? '',
    );
    print('signature: $signature');
    return Uint8List.fromList(hex.decode(signature.substring(2)));
  }
}

class EthWeb3JsSigner implements Signer {
  @override
  FutureOr<Uint8List> sign(Uint8List data, [String? password]) {
    // TODO: implement sign
    throw UnimplementedError();
  }

}