import 'dart:async';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:testingone/noLicense.dart';

import './BackgroundCollectedPage.dart';
import './BackgroundCollectingTask.dart';
import './ChatPage.dart';
import './DiscoveryPage.dart';
import './SelectBondedDevicePage.dart';

// import './helpers/LineChart.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String LicensedMac = '88:FE:DC:65:4D:4E';
  String? deviceId;
  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask? _collectingTask;

  bool _autoAcceptPairingRequests = false;

  String _platformVersion = 'Unknown';
  IosDeviceInfo? iosDeviceInfo;
  AndroidDeviceInfo? androidDeviceInfo;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo!.identifierForVendor; // unique ID on iOS
    } else {
      androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo!.androidId; // unique ID on Android
    }
  }

  void initPlatformState() async {
    var data = await _getId();
    setState(() {
      deviceId = data;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xFF));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.blue,
        leading: Container(
            margin: EdgeInsets.all(5),
            child: Image.asset(
              'assets/fluke.png',
              fit: BoxFit.fill,
            )),
        centerTitle: true,
        actions: [
          Container(
              margin: EdgeInsets.all(5),
              child: Image.asset('assets/asset.png')),
          // _container.connecting(serverName, isConnected, isDisconnecting),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'Connection Setting',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text('Bluetooth Address: $_address',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                )),

            Text('Licensed Device ID: $LicensedMac',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                )),

            SwitchListTile(
              title: const Text('Enable Bluetooth'),
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                // Do the request and update with the true value then
                future() async {
                  // async lambda seems to not working
                  if (value)
                    await FlutterBluetoothSerial.instance.requestEnable();
                  else
                    await FlutterBluetoothSerial.instance.requestDisable();
                }

                future().then((_) {
                  setState(() {});
                });
              },
            ),
            // ListTile(
            //   title: const Text('Connected Device address'),
            //   trailing: Text(_address),
            // ),
            // ListTile(
            //   title: const Text('Connected Device name'),
            //   trailing: Text(_name),
            // ),
            // ListTile(
            //   title: _discoverableTimeoutSecondsLeft == 0
            //       ? const Text("Discoverable")
            //       : Text("Discoverable for ${_discoverableTimeoutSecondsLeft}s"),
            //   subtitle: const Text("Mactek"),
            //   trailing: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Checkbox(
            //         value: _discoverableTimeoutSecondsLeft != 0,
            //         onChanged: null,
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.edit),
            //         onPressed: null,
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.refresh),
            //         onPressed: () async {
            //           print('Discoverable requested');
            //           final int timeout = (await FlutterBluetoothSerial.instance.requestDiscoverable(60))!;
            //           if (timeout < 0) {
            //             print('Discoverable mode denied');
            //           } else {
            //             print('Discoverable mode acquired for $timeout seconds');
            //           }
            //           setState(() {
            //             _discoverableTimeoutTimer?.cancel();
            //             _discoverableTimeoutSecondsLeft = timeout;
            //             _discoverableTimeoutTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
            //               setState(() {
            //                 if (_discoverableTimeoutSecondsLeft < 0) {
            //                   FlutterBluetoothSerial.instance.isDiscoverable.then((isDiscoverable) {
            //                     if (isDiscoverable ?? false) {
            //                       print("Discoverable after timeout... might be infinity timeout :F");
            //                       _discoverableTimeoutSecondsLeft += 1;
            //                     }
            //                   });
            //                   timer.cancel();
            //                   _discoverableTimeoutSecondsLeft = 0;
            //                 } else {
            //                   _discoverableTimeoutSecondsLeft -= 1;
            //                 }
            //               });
            //             });
            //           });
            //         },
            //       )
            //     ],
            //   ),
            // ),

            // Center(
            //     child: Text(
            //   'Communication Setting',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // )),
            // SwitchListTile(
            //   title: const Text('Auto-try specific pin when pairing'),
            //   subtitle: const Text('Pin mactek'),
            //   value: _autoAcceptPairingRequests,
            //   onChanged: (bool value) {
            //     setState(() {
            //       _autoAcceptPairingRequests = value;
            //     });
            //     if (value) {
            //       FlutterBluetoothSerial.instance.setPairingRequestHandler((BluetoothPairingRequest request) {
            //         print("Trying to auto-pair with Pin mactek");
            //         if (request.pairingVariant == PairingVariant.Pin) {
            //           return Future.value("mactek");
            //         }
            //         return Future.value(null);
            //       });
            //     } else {
            //       FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
            //     }
            //   },
            // ),
            ListTile(
              title: ElevatedButton(
                  child: const Text(
                    'Explore Bluetooth devices',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  onPressed: () async {
                    Fluttertoast.showToast(
                      msg: 'Select The Hart Device To Connect',
                      gravity: ToastGravity.CENTER,
                    );

                    final BluetoothDevice? selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DiscoveryPage();
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      Fluttertoast.showToast(
                        msg: 'Discovery of ${selectedDevice.name}',
                        gravity: ToastGravity.CENTER,
                      );

                      print('Discovery -> selected ' + selectedDevice.address);
                    } else {
                      Fluttertoast.showToast(
                        msg: 'No Bluetooth Device Discovered',
                        gravity: ToastGravity.CENTER,
                      );

                      print('Discovery -> no device selected');
                    }
                  }),
            ),

            // ListTile(
            //   title: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       primary: Colors.blue,
            //     ),
            //     child: const Text(
            //   'CONNECT TO DEVICE',
            //   style: TextStyle(
            //     fontSize: 15,
            //   ),
            // ),
            // onPressed: () async {
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text('Select The Hart Device to Send Command'),
            //   ));
            //   final BluetoothDevice? selectedDevice =
            //       await Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return SelectBondedDevicePage(checkAvailability: false);
            //     },
            //   ),
            // );

            // if (selectedDevice != null) {
            //   print('Connect -> selected ' + selectedDevice.address);
            //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //           content: Text('Connected to ${selectedDevice.name}'),
            //         ));

            //         _startChat(context, selectedDevice);
            //       } else {
            //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //           content: Text('No Device Connected'),
            //         ));
            //         print('Connect -> no device selected');
            //       }
            //     },
            //   ),
            // ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () async {
                Fluttertoast.showToast(
                        msg: 'Select The Hart Device',
                        gravity: ToastGravity.CENTER,
                      );
              
                final BluetoothDevice? selectedDevice =
                    await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SelectBondedDevicePage(checkAvailability: false);
                    },
                  ),
                );

                if (selectedDevice != null) {
                  print('Connect -> selected ' + selectedDevice.address);
                   Fluttertoast.showToast(
                        msg: 'Connected to ${selectedDevice.name}',
                        gravity: ToastGravity.CENTER,
                      );
                

                  _startChat(context, selectedDevice);
                } else {
                  Fluttertoast.showToast(
                        msg: 'No Device Connected',
                        gravity: ToastGravity.CENTER,
                      );
                 
                  print('Connect -> no device selected');
                }
              },
              child: AvatarGlow(
                startDelay: Duration(seconds: 1),
                glowColor: Colors.red,
                endRadius: 150.0,
                duration: Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 150,
                  // alignment: AlignmentGeometry.lerp(0, , t),
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(750)),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      'Connect to Device',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LicensedMac != _address
              ? ChatPage(server: server)
              : Nolicense();
        },
      ),
    );
  }

  Future<void> _startBackgroundTask(
    BuildContext context,
    BluetoothDevice server,
  ) async {
    try {
      _collectingTask = await BackgroundCollectingTask.connect(server);
      await _collectingTask!.start();
    } catch (ex) {
      _collectingTask?.cancel();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occured while connecting'),
            content: Text("${ex.toString()}"),
            actions: <Widget>[
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
