import 'package:device_tracker/ble_scanner.dart';
import 'package:device_tracker/helper.dart';
import 'package:device_tracker/track_device.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer2<BleScanner, BleScannerState?>(
        builder: (_, bleScanner, bleScannerState, __) => _DeviceList(
          scannerState: bleScannerState ??
              const BleScannerState(
                discoveredDevices: [],
                scanIsInProgress: false,
              ),
        ),
      );
}

class _DeviceList extends StatelessWidget {
  const _DeviceList({
    required this.scannerState,
  });

  final BleScannerState scannerState;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('${scannerState.discoveredDevices.length} devices found'),
        ),
        body: ListView(
          children: scannerState.discoveredDevices
              .map(
                (result) => ListTile(
                  title: Text(
                    (result.device.name?.isNotEmpty ?? false)
                        ? result.device.name!
                        : result.device.address,
                  ),
                  subtitle: Text(
                    """
RSSI: ${result.rssi}
${Helper.getDeviceDistance(result.rssi).toStringAsFixed(1)}m away (${Helper.getPercentage(result.rssi)}%)
                            """,
                  ),
                  leading: const BluetoothIcon(),
                  onTap: () async {
                    await Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrackDevice(result: result),
                      ),
                    );
                  },
                ),
              )
              .toList(),
        ),
      );
}
