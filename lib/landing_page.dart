import 'package:device_tracker/ble_scanner.dart';
import 'package:device_tracker/device_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class LandingPage extends StatefulWidget {
  final BleScanner scanner;
  const LandingPage(this.scanner, {Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state
        .then((state) => setState(() => _bluetoothState = state));
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() => _bluetoothState = state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Tracker'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Enable Bluetooth'),
            value: _bluetoothState.isEnabled,
            onChanged: (bool value) {
              // Do the request and update with the true value then
              future() async {
                // async lambda seems to not working
                if (value) {
                  await FlutterBluetoothSerial.instance.requestEnable();
                } else {
                  await FlutterBluetoothSerial.instance.requestDisable();
                }
              }

              future().then((_) {
                setState(() {});
              });
            },
          ),
          ListTile(
            title: const Text('Bluetooth status'),
            subtitle: Text(_bluetoothState.toString()),
            trailing: ElevatedButton(
              child: const Text('Settings'),
              onPressed: () {
                FlutterBluetoothSerial.instance.openSettings();
              },
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () async {
                if (!_bluetoothState.isEnabled) return;
                widget.scanner.startTimer();
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DeviceListScreen(),
                  ),
                );
              },
              child: const Text('Explore discovered devices'),
            ),
          )
        ],
      ),
    );
  }
}
