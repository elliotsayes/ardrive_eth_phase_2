import 'package:ardrive_eth_phase_2/signer.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'kdf.dart';

class DriveKeyPage extends StatefulWidget {
  const DriveKeyPage({super.key, required this.signer});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Signer signer;

  @override
  State<DriveKeyPage> createState() => _DriveKeyPageState();
}

class _DriveKeyPageState extends State<DriveKeyPage> {
  late String driveId;
  String driveKey = '...';

  void newDriveId() {
    setState(() {
      driveId = Uuid().v4();
    });
  }

  @override
  void initState() {
    super.initState();
    newDriveId();
  }

  void runDeriveDriveKey() async {
    // Try to initiate connection
    final driveKeySecret = await deriveDriveKey(widget.signer, driveId, 'password');
    final driveKeyData = await driveKeySecret.extractBytes();
    setState(() {
      driveKey = hex.encode(driveKeyData);
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
        title: const Text('Drive Key'),
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
              'Drive ID:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  driveId,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: newDriveId,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Text(
              'Drive Key:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              driveKey,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: runDeriveDriveKey,
        tooltip: 'Increment',
        child: const Icon(Icons.calculate),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
