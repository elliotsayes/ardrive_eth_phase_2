import 'dart:async';
import 'dart:typed_data';

import 'package:ardrive_eth_phase_2/kdf.dart';
import 'package:convert/convert.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

abstract class Signer {
  FutureOr<Uint8List> sign(Uint8List data);
}

class EthWalletConnectSigner implements Signer {
  final WalletConnect connector;
  final String address;

  EthWalletConnectSigner(this.connector, this.address);

  @override
  Future<Uint8List> sign(Uint8List data) async {
    final provider = EthereumWalletConnectProvider(connector);
    final dataHash = await sha256.hash(data).then((value) => value.bytes);
    final message = '0x${hex.encode(dataHash)}';
    print('message: $message');
    final signature = await provider.sign(address: address, message: message);
    // final signature = await provider.sign(message: data, address: address);
    print('signature: $signature');
    assert(signature.startsWith('0x'));
    return Uint8List.fromList(hex.decode(signature.substring(2)));
  }
}

class EthWeb3JsSigner implements Signer {
  @override
  FutureOr<Uint8List> sign(Uint8List data) {
    // TODO: implement sign
    throw UnimplementedError();
  }

}