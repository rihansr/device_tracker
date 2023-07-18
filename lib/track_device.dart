import 'package:device_tracker/ble_scanner.dart';
import 'package:device_tracker/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

class TrackDevice extends StatelessWidget {
  final BluetoothDiscoveryResult result;

  const TrackDevice({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<BleScanner, BleScannerState?>(
      builder: (_, bleScanner, bleScannerState, __) {
        final result = bleScannerState?.discoveredDevices.firstWhere(
                (d) => d.device.address == this.result.device.address,
                orElse: () => this.result) ??
            this.result;
        return Scaffold(
          appBar: AppBar(
            title: Text(result.device.name ?? result.device.address),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${Helper.getPercentage(result.rssi)}%',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
