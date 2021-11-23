import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:testingone/chatContainer.dart';
import 'package:testingone/command.dart';
import 'package:testingone/servicePage.dart';
import 'package:testingone/units.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection? connection;

  var model;
  bool ucllclFlag = false;

  var lcl;
  var units;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  String? _chosenValue;
  List<UnitsModel> unitsModel = Units().units;
  List<String> unitsName = Units().unitsName;

  final _uclKey = GlobalKey<FormState>();
  final _lclKey = GlobalKey<FormState>();

  String uclCode = '0';
  String _uclValue = '0';
  String lclCode = '0';
  String _lclValue = '0';

  TextEditingController lclController = TextEditingController();
  TextEditingController uclController = TextEditingController();
  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;
  bool outer = true;
  bool higher = true;
  bool lower = true;
  Uint8List? resultNum;
  List<int> dataa = [];
  final _formKey = GlobalKey<FormState>();
  final _loopKey = GlobalKey<FormState>();
  List<int> manufacture = [];
  List<int> tag = [];
  List<int> processint = [];
  List<int> tagFinalCmd = [];
  List<int> loopFinalCmd = [];
  List<int> trimming = [];
  List<int> ucllclData = [];
  var current = 0.0;
  var range = 0.0;
  var process1 = 0.0;
  var process2 = 0.0;

  String tagCode = '';
  String loopCode = '';

  bool current_process = false;

  Service _service = Service();
  ChatContainer _container = ChatContainer();

  List<int> currentCMD = Command.currentCMD;
  List<int> tagCMDFirst = Command.tagCMDFirst;
  List<int> tagCMDSecond = Command.tagCMDSecond;
  List<int> loopCMDFirst = Command.loopFirst;
  List<int> loopCMDSecond = Command.loopSecond;
  List<int> despritionTagCMD = Command.despritionTagCMD;
  List<int> manufacturerCMD = Command.manufacturerCMD;
  List<int> processCMD = Command.processCMD;
  List<int> upperlimitlowerTagCMD = Command.upperlimitlowerTagCMD;
  List<int> lowerCMD = Command.lowerCMD;
  List<int> higherCMD = Command.higherCMD;
  List<int> lcluclCmd = Command.lcluclCmd;
  List<int> outerLowCMD = Command.outerLowCMD;
  List<int> outerHighCMD = Command.outerHighCMD;

  bool stopFlag = false;
  bool setTagtestFlag = false;
  bool looptestFlag = false;

  bool manuFact = true;
  bool tagDesp = true;
  List<int> valuechanged = [];
  @override
  void initState() {
    super.initState();

    //recv();
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
    sendinitialCmd();
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  bool validateUcl() {
    print(double.parse(_uclValue));
    print(double.parse(_uclValue));
    if (!_uclValue.isEmpty && double.parse(_uclValue) < 2000.0 && double.parse(_uclValue) >= 0.0) {
      return true;
    }
    return false;
  }

  bool validatelcl() {
    print(double.parse(_lclValue));
    print(double.parse(_lclValue));
    if (!_lclValue.isEmpty && double.parse(_lclValue) < 2000.0 && double.parse(_lclValue) >= 0.0) {
      return true;
    }

    return false;
  }

  void _submitForm3() async {
    final isValid = validateUcl() && validateUcl();
    _uclKey.currentState!.validate();
    _lclKey.currentState!.validate();
    if (isValid) {
      _uclKey.currentState!.save();
      setState(() {
        ucllclFlag = true;
      });
      _sendMessagee(lcluclCmd);
      print('sendingSUbmit..............................................');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Success'),
      ));
      await Future.delayed(const Duration(seconds: 8), () {
        setState(() {
          ucllclFlag = false;
        });
      });
      //
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Enter Valid Tag Name'),
      ));
    }
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      _sendMessagee(tagFinalCmd);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Enter Valid Tag Name'),
      ));
    }
  }

  void _submitForm2() async {
    final isValid = _loopKey.currentState!.validate();
    if (isValid) {
      _loopKey.currentState!.save();
      _sendMessagee(loopFinalCmd);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Enter Valid Current Input'),
      ));
    }
  }

  Future<void> sendinitialCmd() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    await _sendMessagee(manufacturerCMD);
    await Future.delayed(const Duration(seconds: 8), () {
      sendinitialCmdd();
    });
  }

  Future<void> sendinitialCmdd() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    await _sendMessagee(despritionTagCMD);
  }

  Future<void> dataSend() async {
    int i = 0;

    while (i < 1000) {
      //   await Future.delayed(const Duration(seconds: 8), () {});
      i = i + 1;
      if (!stopFlag && !ucllclFlag) {
        print('$stopFlag $ucllclFlag');
        if (valuechanged != dataa) {
          if (current_process) {
            await _sendMessagee(processCMD);
            current_process = false;
            print('processCMD');
          } else {
            await _sendMessagee(currentCMD);
            current_process = true;
            print('currentCMD');
          }
        }
      }
      //

      await Future.delayed(const Duration(seconds: 1), () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(title: Text('HART'),
      centerTitle:true,
      actions: [
        _container.connecting(serverName, isConnected, isDisconnecting),
      ],),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
            //  _container.connecting(serverName, isConnected, isDisconnecting),
              firstPart(),
              currentValue(),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60.0,
                child: ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) => StatefulBuilder(builder: (context, setStateModal) {
                                return AlertDialog(
                                  title: Text('Set the Tag'),
                                  content: Container(
                                    width: 300,
                                    height: 150,
                                    child: Column(
                                      children: [
                                        Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            key: ValueKey('tag'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter a valid TAG Name';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                                              border: const UnderlineInputBorder(),
                                              filled: true,
                                              hintText: 'Tag Name',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                              fillColor: Colors.pink[50],
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                borderSide: BorderSide(color: Colors.grey, width: 2),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                borderSide: BorderSide(color: Colors.transparent),
                                              ),
                                            ),
                                            onSaved: (value) {
                                              tagCode = value!;

                                              final temp = Uint8List.fromList(utf8.encode(tagCode));
                                              setStateModal(() {
                                                tagFinalCmd = tagCMDFirst + temp + tagCMDSecond;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        setTagtestFlag
                                            ? Center(
                                                child: Container(
                                                  margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                                  height: 50,
                                                  // alignment: AlignmentGeometry.lerp(0, , t),
                                                  width: 210,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                                      color: Colors.green),
                                                  child: Center(
                                                    child: Row(children: [
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        'Tag Set Successfully',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Icon(Icons.check)
                                                    ]),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    
                                    ElevatedButton(
                                        onPressed: () {
                                          setStateModal(() {
                                            setTagtestFlag = true;
                                          });
                                          _submitForm();
                                          Future.delayed(const Duration(seconds: 4), () {
                                            setStateModal(() {
                                              setTagtestFlag = false;
                                            });
                                          });
                                        },
                                        child: Text('SetTag')),
                                         ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel')),
                                  ],
                                );
                              }));
                    },
                    child: Text('Set Tag')),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60.0,
                child: ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) => StatefulBuilder(builder: (context, setStateModal) {
                                return AlertDialog(
                                  title: Text('Choose The Trimming'),
                                  content: Container(
                                    width: 300,
                                    height: 200,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        outputtrim(),
                                        lowertrim(),
                                        uppertrim(),
                                      ],
                                    ),
                                  ),
                                );
                              }));
                    },
                    child: Text('Trimming')),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     outputtrim(),
              //     lowertrim(),
              //     uppertrim(),
              //   ],
              // ),
             // Text('Trim: $trimming'),
  SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60.0,
                child: ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) => StatefulBuilder(builder: (context, setStateModal) {
                                return AlertDialog(
                                  title: Text("Action needed"),
                                  content: Container(
                                    width: MediaQuery.of(context).size.width * 1,
                                    height: 300,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                            Text('Select Unit'),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(color: Colors.amber[50]),
                                              padding: const EdgeInsets.all(0.0),
                                              width: 120,
                                              child: DropdownButton<String>(
                                                value: _chosenValue,
                                                //elevation: 5,
                                                style: TextStyle(color: Colors.black),

                                                items: unitsName.map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                hint: Flexible(
                                                  child: Text(
                                                    "choose unit",
                                                    style: TextStyle(
                                                        color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                                onChanged: (String? value) {
                                                  for (var unit in unitsModel) {
                                                    if (unit.name == value) {
                                                      uclCode = unit.ucl;
                                                      lclCode = unit.lcl;
                                                    }
                                                  }
                                                  uclController.text = uclCode;
                                                  lclController.text = lclCode;
                                                  _uclKey.currentState!.validate();
                                                  _lclKey.currentState!.validate();
                                                  setStateModal(() {
                                                    ucllclFlag = true;
                                                    uclCode = uclCode;
                                                    lclCode = lclCode;
                                                    _chosenValue = value;
                                                  });
                                                },
                                              ),
                                            )
                                          ]),
                                        ),
                                        Text('UclCode $uclCode'),
                                        Text('LclCode $lclCode'),
                                        Form(
                                          key: _uclKey,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.5,
                                            child: TextFormField(
                                              key: ValueKey('ucl'),
                                              validator: (value) {
                                                print(double.parse(value!));
                                                print('nooooooo');
                                                if (double.parse(value) <= 2000.0 && double.parse(value) >= 0.0) {
                                                  print('double.parse(value)');
                                                  return '';
                                                }
                                                return 'Enter UCL Value between 0 to 2000';
                                              },
                                              keyboardType: TextInputType.number,
                                              controller: uclController,
                                              onChanged: (String? value) {
                                                _uclValue = value!;
                                              },

                                              // inputFormatters: [
                                              //   FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+.[0-9]+$')),
                                              // ],
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                              decoration: InputDecoration(
                                                errorText: 'Enter the Value',
                                                contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                border: const UnderlineInputBorder(),
                                                filled: true,
                                                hintText: 'UCL value',
                                                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.grey, width: 2),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.transparent),
                                                ),
                                              ),
                                              onSaved: (value) {
                                                uclCode = value!;
                                                final temp = Uint8List.fromList(utf8.encode(uclCode));
                                                setStateModal(() {
                                                  uclCode = uclCode;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Form(
                                          key: _lclKey,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.5,
                                            child: TextFormField(
                                              key: ValueKey('lcl'),
                                              validator: (value) {
                                                print(double.parse(value!));
                                                if (double.parse(value) <= 2000.0 && double.parse(value) >= 0.0) {
                                                  print(double.parse(value));
                                                  return '';
                                                }
                                                return 'Enter LCL Value between 0 to 2000';
                                              },
                                              keyboardType: TextInputType.number,
                                              controller: lclController,
                                              onChanged: (String? value) {
                                                _uclValue = value!;
                                              },

                                              // inputFormatters: [
                                              //   FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+.[0-9]+$')),
                                              // ],
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                              decoration: InputDecoration(
                                                errorText: validatelcl() ? null : 'Enter the Value',
                                                contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                border: const UnderlineInputBorder(),
                                                filled: true,
                                                hintText: 'LCL value',
                                                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.grey, width: 2),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.transparent),
                                                ),
                                              ),
                                              onSaved: (value) {
                                                lclCode = value!;
                                                final temp = Uint8List.fromList(utf8.encode(lclCode));
                                                setStateModal(() {
                                                  lclCode = lclCode;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(onPressed: _submitForm3, child: Text('SET')),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          ucllclFlag = false;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                  ],
                                );
                              }));
                    },
                    child: Text('UCLLCL')),
              ),
              //   ucllcl(),
            //  Text('lclucl:$ucllclData'),
  SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60.0,
                child: ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) => StatefulBuilder(builder: (context, setStateModal) {
                                return AlertDialog(
                                  title: Column(
                                    mainAxisAlignment:MainAxisAlignment.center,
                                    children: [
                                       Text('Loop Test',style:TextStyle(fontWeight: FontWeight.w700),),
                                       SizedBox(height: 5,),
                                      Text('Enter the Current value in mA.'),
                                    ],
                                  ),
                                  content: Container(
                                    width: 300,
                                    height: 200,
                                    child: Column(
                                      children: [
                                        Form(
                                          key: _loopKey,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.6,
                                            child: TextFormField(
                                              key: ValueKey('loopKey'),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter Current value';
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                border: const UnderlineInputBorder(),
                                                filled: true,
                                                hintText: 'Loop Test Current value',
                                                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                                fillColor: Colors.pink[50],
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                  borderSide: BorderSide(color: Colors.grey, width: 2),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                  borderSide: BorderSide(color: Colors.transparent),
                                                ),
                                              ),
                                              onSaved: (value) {
                                                loopCode = value!;
                                                final temp = Uint8List.fromList(utf8.encode(loopCode));
                                                setState(() {
                                                  loopFinalCmd = loopCMDFirst + temp + loopCMDSecond;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              setStateModal(() {
                                                looptestFlag = true;
                                              });
                                              _submitForm2();
                                              Future.delayed(const Duration(seconds: 4), () {
                                                setStateModal(() {
                                                  looptestFlag = false;
                                                });
                                              });
                                            },
                                            child: Text('Loop Test')),
                                        looptestFlag
                                            ? Center(
                                                child: Container(
                                                  margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                                  height: 50,
                                                  // alignment: AlignmentGeometry.lerp(0, , t),
                                                  width: 210,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                                      color: Colors.green),
                                                  child: Center(
                                                    child: Row(children: [
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        'Loop Test Success',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Icon(Icons.check)
                                                    ]),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    //loopSet(),
                                  ),
                                );
                              }));
                    },
                    child: Text('Loop Test')),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget currentCMDWidget() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      height: 30,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.amber,
      ),
      child: ElevatedButton(
          child: Text(
            'Current Command',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          onPressed: () async {
            dataSend();
          }),
    );
  }

  Widget ulpCMDWidget() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.amber,
      ),
      child: ElevatedButton(
          child: Text(
            'ulp Command',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          onPressed: () async {
            _sendMessagee(upperlimitlowerTagCMD);
          }),
    );
  }

  Widget currentValue() {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
        height: MediaQuery.of(context).size.height * 0.24,
        width: MediaQuery.of(context).size.width * 0.7,
        padding: const EdgeInsets.all(10.0),
        //  width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.amber,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'current: $current',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Range: $range',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Process: $process1',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'PRange: $process2',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            currentCMDWidget(),
          ],
        ));
  }

  Widget tagSet() {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextFormField(
              key: ValueKey('tag'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid TAG Name';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                border: const UnderlineInputBorder(),
                filled: true,
                hintText: 'Tag Name',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                fillColor: Colors.pink[50],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              onSaved: (value) {
                tagCode = value!;

                final temp = Uint8List.fromList(utf8.encode(tagCode));
                setState(() {
                  tagFinalCmd = tagCMDFirst + temp + tagCMDSecond;
                });
              },
            ),
          ),
        ),
        ElevatedButton(onPressed: _submitForm, child: Text('SetTag')),
      ],
    );
  }

  Widget loopSet() {
    return Column(
      children: [
        Form(
          key: _loopKey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextFormField(
              key: ValueKey('loopKey'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter pressure value';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                border: const UnderlineInputBorder(),
                filled: true,
                hintText: 'Loop Test Pressure Value',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                fillColor: Colors.pink[50],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              onSaved: (value) {
                loopCode = value!;
                final temp = Uint8List.fromList(utf8.encode(loopCode));
                setState(() {
                  loopFinalCmd = loopCMDFirst + temp + loopCMDSecond;
                });
              },
            ),
          ),
        ),
        ElevatedButton(onPressed: _submitForm2, child: Text('Loop Test')),
        looptestFlag
            ? Container(
                margin: const EdgeInsets.fromLTRB(100, 10, 0, 10),
                height: 10,
                // alignment: AlignmentGeometry.lerp(0, , t),
                width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.green),
                child: Center(
                  child: Text(
                    'Loop Test Success',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

//   Widget buttuonCmd(String cmdName, List<int> command) {
//     return Container(
//       margin: const EdgeInsets.all(10.0),
//       height: 30,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//         color: Colors.amber,
//       ),
//       child: ElevatedButton(
//           child: Text(
//             cmdName,
//             style: TextStyle(
//               fontSize: 15,
//             ),
//           ),
//           onPressed: () async {
//             //_sendMessagee(manufacturerCMD);
// //await Future.delayed(const Duration(seconds: 2), (){  onrecData();});

//             // _sendMessagee(despritionTagCMD);

//             //      await Future.delayed(const Duration(seconds: 2), (){  onrecData();});
//             _sendMessagee(command);
//           }),
//     );
//   }

  Future<void> _sendMessagee(List<int> text) async {
    print(text);
    setState(() {
      dataa.clear();
    });
    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(text));
        await connection!.output.allSent;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('All Command Sent '),
        ));
      } catch (e) {
        setState(() {});
      }
    }
  }

  void breaking(dynamic data) {
    Iterable inReverse = data.reversed;
    var reverseCMD = inReverse.toList();
    List<dynamic> value = reverseCMD.sublist(1, 9);
    Iterable isReverse = value.reversed;
    var reverseValue = isReverse.toList();
    List<dynamic> currentvalue = reverseValue.sublist(0, 4);
    List<dynamic> processVariablevalue = reverseValue.sublist(4, 8);
    var currentValue = _service.convertion(currentvalue);
    var processVariable = _service.convertion(processVariablevalue);
    setState(() {
      current = currentValue;
      range = processVariable;
    });
  }

  void breaking2(dynamic data) {
    Iterable inReverse = data.reversed;
    var reverseCMD = inReverse.toList();
    List<dynamic> value = reverseCMD.sublist(1, 9);
    Iterable isReverse = value.reversed;
    var reverseValue = isReverse.toList();
    List<dynamic> currentvalue = reverseValue.sublist(0, 4);
    List<dynamic> processVariablevalue = reverseValue.sublist(4, 8);
    var currentValue = _service.convertion(currentvalue);
    var processVariable = _service.convertion(processVariablevalue);
    setState(() {
      process1 = currentValue;
      process2 = processVariable;
    });
  }

  void _onDataReceived(Uint8List data) async {
    if (!ucllclFlag) {
      if (!stopFlag) {
        if (manuFact) {
          for (int i = 0; i < data.length; i++) {
            if (manufacture.length > 15 && data[i] == 255) manuFact = false;
            setState(() {
              manufacture.add(data[i]);
            });
          }
        } else if (tagDesp) {
          for (int i = 0; i < data.length; i++) {
            if (tag.length > 15 && data[i] == 255) tagDesp = false;
            setState(() {
              tag.add(data[i]);
            });
          }
        } else {
          for (int i = 0; i < data.length; i++) {
            if (current_process) {
              setState(() {
                dataa.add(data[i]);
              });
            } else {
              setState(() {
                processint.add(data[i]);
              });
            }
          }
          if (dataa.length >= 24) {
            breaking(dataa);
          } else if (processint.length >= 24) {
            breaking2(processint);
          }
        }
      } else {
        for (int i = 0; i < trimming.length; i++) {
          // if (trimming.length > 15 && data[i] == 255) manuFact = false;
          setState(() {
            trimming.add(data[i]);
          });
        }
      }
    } else {
      for (int i = 0; i < ucllclData.length; i++) {
        // if (trimming.length > 15 && data[i] == 255) manuFact = false;
        setState(() {
          ucllclData.add(data[i]);
        });
      }
    }
    if (data.isEmpty) {
      setState(() {
        valuechanged = dataa;
      });
    }

    // Allocate buffer for parsed data
    // int backspacesCounter = 0;
    // data.forEach((byte) {
    //   if (byte == 8 || byte == 127) {
    //     backspacesCounter++;
    //   }
    // });
    // Uint8List buffer = Uint8List(data.length - backspacesCounter);
    // int bufferIndex = buffer.length;

    // // Apply backspace control character
    // backspacesCounter = 0;
    // for (int i = data.length - 1; i >= 0; i--) {
    //   if (data[i] == 8 || data[i] == 127) {
    //     backspacesCounter++;
    //   } else {
    //     if (backspacesCounter > 0) {
    //       backspacesCounter--;
    //     } else {
    //       buffer[--bufferIndex] = data[i];
    //     }
    //   }
    // }
    // String dataString = String.fromCharCodes(buffer);
    // int index = buffer.indexOf(13);
  }

  Widget firstPart() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            children: [
              Flexible(child: Text('Manufacturer Name:')),
              Flexible(
                  child: Text(
                '$manufacture',
                style: TextStyle(
                  fontSize: 5,
                ),
              ))
            ],
          ),
          Row(
            children: [
              Flexible(child: Text('Tag Name:')),
              Flexible(
                  child: Text(
                '$tag',
                style: TextStyle(
                  fontSize: 5,
                ),
              ))
            ],
          ),
          // Row(
          //   children: [Text('Manufacture Name:'), Text('$tag')],
          // ),
          // Row(
          //   children: [Text('Lcl Name:'), Text('$tag')],
          // ),
          // Row(
          //   children: [Text('units Name:'), Text('$tag')],
          // ),
        ],
      ),
    );
  }

  Widget uppertrim() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      margin: EdgeInsets.all(5),
      decoration: new BoxDecoration(color: Colors.blue[100]),
      child: Center(
        child: SizedBox(
             width:200,
          child: ElevatedButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Action needed"),
                  content: Text("Do you want to do upper trim"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        higher = true;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        higher = false;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                ),
              );

              if (higher) {
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Action needed"),
                    content: Text("Apply High Pressure"),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Please Wait till pressure becomes stable"),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Enter the pressure value applied"),
                    content: TextField(),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          await _sendMessagee(higherCMD);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('$higherCMD'),
                          ));
                          Navigator.of(ctx).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Action needed"),
                    content: Text("Upper Trim Completed Successfull"),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          await Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              stopFlag = true;
                            });
                          });
                          higher = false;
                          Navigator.of(ctx).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text("Up Trim"),
          ),
        ),
      ),
    );
  }

  Widget lowertrim() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      margin: EdgeInsets.all(5),
      decoration: new BoxDecoration(color: Colors.blue[100]),
      child: Center(
        child: SizedBox(
             width:200,
          child: ElevatedButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Action needed"),
                  content: Text("Do you want to do lower trim"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        lower = true;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        lower = false;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                ),
              );

              if (lower) {
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Action needed"),
                    content: Text("Apply Low Pressure"),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Please Wait till pressure becomes stable"),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Enter the pressure value applied"),
                    content: TextField(),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          await _sendMessagee(lowerCMD);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('$lowerCMD'),
                          ));
                          Navigator.of(ctx).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Action needed"),
                    content: Text("Lower Trim Completed Successfull"),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          await Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              stopFlag = true;
                            });
                          });
                          lower = false;
                          Navigator.of(ctx).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text("Low Trim"),
          ),
        ),
      ),
    );
  }

  Widget outputtrim() {
    return Container(
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: new BoxDecoration(color: Colors.blue[100]),
      child: Center(
        child: SizedBox(
             width:200,
          child: ElevatedButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Action needed"),
                  content: Text("Connect Reference meter and press ok"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Action needed"),
                  content: Text("press OK to trim output current for 4 mA"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        await _sendMessagee(outerLowCMD);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('$outerLowCMD'),
                        ));
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Enter the meter value"),
                  content: TextField(),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Action needed"),
                  content: Text("Feild device output 4ma equal to reference meter?"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        outer = true;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("YES"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        outer = false;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("NO"),
                    ),
                  ],
                ),
              );
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Action needed"),
                  content: Text("press OK to trim output current for 20 mA"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        await _sendMessagee(outerHighCMD);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('$outerHighCMD'),
                        ));
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Enter the meter value"),
                  content: TextField(),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        outer = true;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        outer = false;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                ),
              );
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Action needed"),
                  content: Text("Feild device output 20ma equal to reference meter?"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        outer = true;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        outer = false;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                ),
              );

              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Action needed"),
                  content: Text("Loop return to automatic control"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        await Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            stopFlag = true;
                          });
                        });
                        outer = false;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            },
            child: Text("O/p Trim"),
          ),
        ),
      ),
    );
  }

  Widget ucllcl() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.45,
        child: Card(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('Select Unit'),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.amber[50]),
                    padding: const EdgeInsets.all(0.0),
                    width: 150,
                    child: DropdownButton<String>(
                      value: _chosenValue,
                      //elevation: 5,
                      style: TextStyle(color: Colors.black),

                      items: unitsName.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Flexible(
                        child: Text(
                          "choose unit",
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      onChanged: (String? value) {
                        for (var unit in unitsModel) {
                          if (unit.name == value) {
                            uclCode = unit.ucl;
                            lclCode = unit.lcl;
                          }
                        }
                        uclController.text = uclCode;
                        lclController.text = lclCode;
                        _uclKey.currentState!.validate();
                        _lclKey.currentState!.validate();
                        setState(() {
                          ucllclFlag = true;
                          uclCode = uclCode;
                          lclCode = lclCode;
                          _chosenValue = value;
                        });
                      },
                    ),
                  )
                ]),
              ),
              Text('UclCode $uclCode'),
              Text('LclCode $lclCode'),
              Form(
                key: _uclKey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    key: ValueKey('ucl'),
                    validator: (value) {
                      print(double.parse(value!));
                      print('nooooooo');
                      if (double.parse(value) <= 2000.0 && double.parse(value) >= 0.0) {
                        print('double.parse(value)');
                        return '';
                      }
                      return 'Enter UCL Value between 0 to 2000';
                    },
                    keyboardType: TextInputType.number,
                    controller: uclController,
                    onChanged: (String? value) {
                      _uclValue = value!;
                    },

                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+.[0-9]+$')),
                    // ],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      errorText: 'Enter the Value',
                      contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                      border: const UnderlineInputBorder(),
                      filled: true,
                      hintText: 'UCL value',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    onSaved: (value) {
                      uclCode = value!;
                      final temp = Uint8List.fromList(utf8.encode(uclCode));
                      setState(() {
                        uclCode = uclCode;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Form(
                key: _lclKey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    key: ValueKey('lcl'),
                    validator: (value) {
                      print(double.parse(value!));
                      if (double.parse(value) <= 2000.0 && double.parse(value) >= 0.0) {
                        print(double.parse(value));
                        return '';
                      }
                      return 'Enter LCL Value between 0 to 2000';
                    },
                    keyboardType: TextInputType.number,
                    controller: lclController,
                    onChanged: (String? value) {
                      _uclValue = value!;
                    },

                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+.[0-9]+$')),
                    // ],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      errorText: validatelcl() ? null : 'Enter the Value',
                      contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                      border: const UnderlineInputBorder(),
                      filled: true,
                      hintText: 'LCL value',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    onSaved: (value) {
                      lclCode = value!;
                      final temp = Uint8List.fromList(utf8.encode(lclCode));
                      setState(() {
                        lclCode = lclCode;
                      });
                    },
                  ),
                ),
              ),
              ElevatedButton(onPressed: _submitForm3, child: Text('SET')),
            ],
          ),
          elevation: 10,
        ),
      ),
    );
  }
}
