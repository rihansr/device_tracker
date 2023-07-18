import 'dart:developer';
import 'package:device_tracker/ble_scanner.dart';
import 'package:device_tracker/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  [
    Permission.location,
    Permission.storage,
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.bluetoothScan
  ].request().then((status) {
    final scanner = BleScanner(logMessage: (message) => log(message));

    runApp(
      MultiProvider(
        providers: [
          Provider.value(value: scanner),
          StreamProvider<BleScannerState?>(
            create: (_) => scanner.state,
            initialData: const BleScannerState(
              discoveredDevices: [],
              scanIsInProgress: false,
            ),
          ),
        ],
        child: MyApp(scanner: scanner),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  final BleScanner scanner;
  const MyApp({Key? key, required this.scanner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      debugShowCheckedModeBanner: false,
      home: LandingPage(scanner),
    );
  }
}
