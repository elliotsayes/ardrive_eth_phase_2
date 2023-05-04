import 'dart:async';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:convert/convert.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class EthWalletConnectWallet extends Wallet {
  final WalletConnect connector;
  final String address;

  EthWalletConnectWallet(this.connector, this.address);

  @override
  ChainCode get chainCode => ChainCode.Ethereum;

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

  @override
  Future<String> getAddress() {
    return Future.value(address);
  }

  @override
  Future<String> getOwner() {
    // Ethereum-signed txs appear to use the address as owner? 
    // Source: https://github.com/Bundlr-Network/js-sdk/blob/main/src/web/currencies/ethereum.ts#L105
    return Future.value(address);
  }
}

class EthWeb3JsWallet extends Wallet {
  @override
  ChainCode get chainCode => ChainCode.Ethereum;

  @override
  Future<Uint8List> sign(Uint8List data, [String? password]) {
    // TODO: implement sign
    throw UnimplementedError();
  }

  @override
  Future<String> getAddress() {
    // TODO: implement getAddress
    throw UnimplementedError();
  }

  @override
  Future<String> getOwner() {
    // TODO: implement getOwner
    throw UnimplementedError();
  }
}