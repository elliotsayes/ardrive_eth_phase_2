import 'dart:typed_data';

import 'package:ardrive_eth_phase_2/drive_key.dart';
import 'package:ardrive_eth_phase_2/signer.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_qrcode_modal_dart/walletconnect_qrcode_modal_dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Connect to Metamask'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

        // await Future.delayed(const Duration(seconds: 5));

        final wallet = EthWalletConnectWallet(connector, session.accounts[0]);
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: buttonEnabled ? walletConnect : null,
        tooltip: 'Increment',
        child: const Icon(Icons.arrow_outward),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
