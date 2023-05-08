import 'dart:async';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:convert/convert.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:webthree/credentials.dart' hide Wallet;

class EthWalletConnectWallet extends Wallet {
  final WalletConnect connector;
  final String address;

  EthWalletConnectWallet(this.connector, this.address);

  @override
  ChainCode get chainCode => ChainCode.Ethereum;

  // Comparison of signing methods:
  // - `sign`: deprecated
  // - `signTypeData`: Used to efficiently verify on-chain (unnecessary)
  // - `personalSign`: Simplest, supports hardware wallets
  // see more: https://docs.metamask.io/wallet/how-to/sign-data/
  //
  // `password` is not needed, and does not affect the signature
  // see more: https://ethereum.stackexchange.com/a/69879
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
    // Will confirm in Phase 3
    // Source: https://github.com/Bundlr-Network/js-sdk/blob/main/src/web/currencies/ethereum.ts#L105
    return Future.value(address);
  }
}

class EthJsWallet extends Wallet {
  final CredentialsWithKnownAddress credentials;
  final String address;

  EthJsWallet(this.credentials, this.address);

  @override
  ChainCode get chainCode => ChainCode.Ethereum;

  @override
  Future<Uint8List> sign(Uint8List data, [String? password]) async {
    final signature = await credentials.signPersonalMessage(data);
    print('signature: $signature');
    return Future.value(signature);
  }

  @override
  Future<String> getAddress() {
    return Future.value(address);
  }

  @override
  Future<String> getOwner() {
    return Future.value(address);
  }
}