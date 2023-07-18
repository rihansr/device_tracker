import 'dart:async';
import 'package:device_tracker/reactive_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BleScanner implements ReactiveState<BleScannerState> {
  BleScanner({
    required Function(String message) logMessage,
  }) : _logMessage = logMessage;

  final void Function(String message) _logMessage;
  late Timer? _restartDiscoveryTimer;
  final StreamController<BleScannerState> _stateStreamController =
      StreamController();

  final _devices = <BluetoothDiscoveryResult>[];

  @override
  Stream<BleScannerState> get state => _stateStreamController.stream;

  void startScan() {
    _logMessage('Start ble discovery');
    _subscription?.cancel();
    _subscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      final knownDeviceIndex =
          _devices.indexWhere((d) => d.device.address == r.device.address);
      if (knownDeviceIndex >= 0) {
        _devices[knownDeviceIndex] = r;
      } else {
        _devices.add(r);
      }
      _pushState();
    }, onError: (Object e) => _logMessage('Device scan fails with error: $e'));
    _pushState();
  }

  startTimer() {
    startScan();
    _restartDiscoveryTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        startScan();
      },
    );
  }

  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> stopScan() async {
    _logMessage('Stop ble discovery');

    await _subscription?.cancel();
    _subscription = null;
    _restartDiscoveryTimer?.cancel();
    _pushState();
  }

  Future<void> dispose() async {
    _restartDiscoveryTimer?.cancel();
    await _stateStreamController.close();
  }

  StreamSubscription? _subscription;
}

@immutable
class BleScannerState {
  const BleScannerState({
    required this.discoveredDevices,
    required this.scanIsInProgress,
  });

  final List<BluetoothDiscoveryResult> discoveredDevices;
  final bool scanIsInProgress;
}
