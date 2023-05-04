import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

// conditionally import dependencies in order to support web and other platform builds from a single codebase

import 'package:ardrive_eth_phase_2/wallet.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart'
    if (dart.library.io) 'package:webthree/lib/src/browser/js-stub.dart'
    if (dart.library.js) 'package:js/js.dart';
import 'package:webthree/browser.dart'
    if (dart.library.io) 'package:webthree/lib/src/browser/dart_wrappers_stub.dart'
    if (dart.library.js) 'package:webthree/browser.dart';
import 'package:webthree/webthree.dart';

import 'drive_key.dart';

@JS()
@anonymous
class JSrawRequestParams {
  external String get chainId;

  // Must have an unnamed factory constructor with named arguments.
  external factory JSrawRequestParams({String chainId});
}

class MetamaskButton extends StatefulWidget {
  const MetamaskButton({super.key});

  @override
  State<MetamaskButton> createState() => _MetamaskButtonState();
}

class _MetamaskButtonState extends State<MetamaskButton> {
  String text = 'Ready';
  bool buttonEnabled = true;

  late final Ethereum eth;
  late final Web3Client client;

  @override
  void initState() {
    super.initState();

    final maybeEth = window.ethereum;
    if (maybeEth == null) {
      print('MetaMask is not available');
      return;
    } else {
      eth = maybeEth;
    }

    client = Web3Client.custom(eth.asRpcService());
  }

  void metamaskConnect() async {
    // Try to initiate connection
    setState(() {
      buttonEnabled = false;
    });
    final nav = Navigator.of(context);
    final credentials = await eth.requestAccount();
    final address = credentials.address;

    setState(() {
      text = "Connected: ${address.hex}";
    });

    // await Future.delayed(const Duration(seconds: 5));

    final wallet = EthJsWallet(credentials, address.hex);
    // final testSig = await signer.sign(Uint8List.fromList([0x00, 0xff]), 'lol');
    // print('testSig: $testSig');

    await Future.delayed(const Duration(seconds: 1));

    nav.pushReplacement(
      MaterialPageRoute(
        builder: (context) => DriveKeyPage(
          wallet: wallet,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: buttonEnabled ? metamaskConnect : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'MetaMask',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
