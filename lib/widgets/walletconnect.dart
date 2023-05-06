import 'package:ardrive_eth_phase_2/wallet.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_qrcode_modal_dart/walletconnect_qrcode_modal_dart.dart';

import '../pages/drive_key.dart';

class WalletConnectButton extends StatefulWidget {
  const WalletConnectButton({super.key});

  @override
  State<WalletConnectButton> createState() => _WalletConnectButtonState();
}

class _WalletConnectButtonState extends State<WalletConnectButton> {
  String text = 'Ready';
  bool buttonEnabled = true;

  late final WalletConnect connector;
  late final WalletConnectQrCodeModal qrCodeModal;

  @override
  void initState() {
    super.initState();
    connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta( // <-- Meta data of your app appearing in the wallet when connecting
        name: 'QRCodeModalExampleApp',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );
    qrCodeModal = WalletConnectQrCodeModal(
      connector: connector,
    );
    qrCodeModal.registerListeners(
      onConnect: (session) async {
        setState(() {
          buttonEnabled = false;
        });
        final nav = Navigator.of(context);
        if (session.accounts.length != 1) {
          setState(() {
            text = "Error, non-single accounts: ${session.accounts.join(', ')}";
          });
          return;
        }

        setState(() {
          text = "Connected: ${session.accounts[0]}";
        });
        
        await Future.delayed(const Duration(seconds: 1));

        final wallet = EthWalletConnectWallet(connector, session.accounts[0]);

        void cleanup() async {
          print('WalletConnect cleanup');
          await connector.killSession();
          connector.reconnect();
          setState(() {
            text = 'Session Closed';
            buttonEnabled = true;
          });
        }

        nav.push(
          MaterialPageRoute(
            builder: (context) => DriveKeyPage(
              wallet: wallet,
              onBack: cleanup,
            ),
          ),
        );
      }
    );
  }

  void walletConnect() async {
    // Try to initiate connection
    await qrCodeModal.connect(context).catchError((error) {
      setState(() {
        text = "Error: $error";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: buttonEnabled ? walletConnect : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'WalletConnect',
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
