import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:testingone/chatContainer.dart';
import 'package:testingone/chatService.dart';
import 'package:testingone/command.dart';
import 'package:testingone/conversion2.dart';
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
  //Controllers
  TextEditingController lclController = TextEditingController();
  TextEditingController uclController = TextEditingController();
  TextEditingController textEditingController = new TextEditingController();
  ScrollController listScrollController = new ScrollController();

  //bluetooth essential
  BluetoothConnection? connection;

  //flags
  bool ucllclFlag = true;
  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);
  bool isDisconnecting = false;
  bool outer = true;
  bool higher = true;
  bool lower = true;
  bool current_process = false;
  bool stopFlag = false;
  bool setTagtestFlag = false;
  bool setUcltestFlag = false;
  bool looptestFlag = false;
  bool manuFact = true;
  bool tagDesp = true;
  bool fetchlcluclCMD = false;
  bool isValidUCLLCL = false;
  bool isValidLoop = false;
  bool screenLoaded = false;

  //key
  final _uclKey = GlobalKey<FormState>();
  final _lclKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _loopKey = GlobalKey<FormState>();
  final _lowKey = GlobalKey<FormState>();
  final _highKey = GlobalKey<FormState>();

  //list
  List<_Message> messages = List<_Message>.empty(growable: true);
  List<UnitsModel> unitsModel = Units().units;
  List<String> unitsName = Units().unitsName;
  List<int> dataa = [];
  List<int> manufacture = [];
  List<int> tag = [];
  List<int> processint = [];
  List<int> tagFinalCmd = [];
  List<int> loopFinalCmd = [];
  List<int> trimming = [];
  List<int> ucllclData = [];
  List<int> valuechanged = [];
  List<int> fetchlcluclCMDData = [];

  List<int> uclinput = [];
  List<int> lclinput = [];
  List<int> unitinput = [];

  //variables
  var model;
  var lcl;
  var units;
  var current = 0.0;
  var range = 0.0;
  var process1 = 0.0;
  var process2 = 0.0;

  //String
  String? _chosenValue;
  String uclCode = '0';
  String _uclValue = '0';
  String lclCode = '0';
  String _lclValue = '0';
  String tagCode = '';
  String unitNamedValue = '';

//numbers
  Uint8List? resultNum;
  double uCLVALUE = 0.0;
  double lCLVALUE = 0.0;
  double loopCode = 0.0;
  int id = 4;
  int unitsnamee = 0;

  //commands
  List<int> currentCMD = [];
  List<int> tagCMDFirst = [];
  List<int> tagCMDSecond = [];
  List<int> loopCMDFirst = [];
  List<int> loopCMDSecond = [];
  List<int> despritionTagCMD = [];
  List<int> manufacturerCMD = [];
  List<int> processCMD = [];
  List<int> upperlimitlowerTagCMD = [];
  List<int> lowerCMD = [];
  List<int> higherCMD = [];
  List<int> lcluclCmd = [];
  List<int> outerLowCMD = [];
  List<int> outerHighCMD = [];
  List<int> zeroTrim = [];
  List<int> macaddress = [];

  List<int> lcluclCmd1 = [];
  List<int> lcluclCmd2 = [];
  List<int> refreshCmd = [];
  List<int> temptagCode = [];
  //others
  Service _service = Service();
  ChatContainer _container = ChatContainer();

  var check1;
  void commandInitialize() {
    // await _sendMessagee([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x02, 0x00, 0x00, 0x00, 0x02]);
    manufacturerCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.manufacturerCMD + [0x0D, 0x0A];
    despritionTagCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.despritionTagCMD + [0x0D, 0x0A];
    upperlimitlowerTagCMD =
        [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.upperlimitlowerTagCMD + [0x0D, 0x0A];
    processCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.processCMD + [0x0D, 0x0A];
    currentCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.currentCMD + [0x0D, 0x0A];

    tagCMDFirst = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.tagCMDFirst;
    tagCMDSecond = Command.tagCMDSecond + [0x0D, 0x0A];

    loopCMDFirst = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.loopFirst;
    loopCMDSecond = Command.loopSecond + [0x0D, 0x0A];

    higherCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.higherCMD + [0x0D, 0x0A];

    lowerCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.lowerCMD + [0x0D, 0x0A];
    outerHighCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.outerHighCMD + [0x0D, 0x0A];
    outerLowCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.outerLowCMD + [0x0D, 0x0A];

    zeroTrim = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.zeroTrimCmd + [0x0D, 0x0A];

    lcluclCmd = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.lcluclCmd + [0x0D, 0x0A];

    lcluclCmd1 = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.lcluclCmd1;
    lcluclCmd2 = Command.lcluclCmd2 + [0x0D, 0x0A];

    refreshCmd = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.FetchlcluclCMD + [0x0D, 0x0A];

    sendinitialCmd();
  }

  @override
  void initState() {
    print(widget.server.address);

    macaddress = [0xB7, 0x04, 0x2D, 0xAD, 0xCF];
    //numberConvert(widget.server.address);

    print(refreshCmd);

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
      print(error);
    });
    //  if (isConnected) {
    commandInitialize();

    // }
    super.initState();
  }

  List<int> numberConvert(String string) {
    List<String> myList = [];
    int i = 0;
    while (i < string.length) {
      if (string[i] == ':') {
        myList.add(string[i - 2] + string[i - 1]);
      }
      i++;
    }
    myList.add(string[i - 2] + string[i - 1]);
    List<int> ch = [];
    int j = 0;
    for (int y = 0; y < myList.length; y++) {
      String data = (myList[y]);
      ch.add(int.parse(data, radix: 16));
    }
    return ch;
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }

  Future<void> _sendMessagee(List<int> text) async {
    print('----------------------------------------------------------------------------');
    print('Command Sent : $text');
    print('----------------------------------------------------------------------------');
    setState(() {
      dataa.clear();
    });
    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(text));
        await connection!.output.allSent;
      } catch (e) {
        setState(() {});
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Command Sent:$text'),
    ));
  }

  void _onDataReceived(Uint8List data) async {
    //if (!fetchlcluclCMD) {
    //  if (!ucllclFlag) {
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
      } else if (ucllclFlag) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Recieved UCL:$ucllclFlag --- $fetchlcluclCMDData'),
        ));
        for (int i = 0; i < data.length; i++) {
          //   if (ucllclData.length > 15 && data[i] == 255) ucllclFlag = false;
          setState(() {
            fetchlcluclCMDData.add(data[i]);
          });
        }
        if (fetchlcluclCMDData.length >= 24) {
          breaking3(fetchlcluclCMDData);
        }
        //      for (int i = 0; i < ucllclData.length; i++) {
        //    if (ucllclData.length > 15 && data[i] == 255) ucllclFlag = false;
        //   setState(() {
        //     ucllclData.add(data[i]);
        //   });
        // }
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
    // } else {
    //   for (int i = 0; i < ucllclData.length; i++) {
    //     // if (trimming.length > 15 && data[i] == 255) manuFact = false;
    //     setState(() {
    //       ucllclData.add(data[i]);
    //     });
    //   }
    // }
    // }
    //  else {
    //   for (int i = 0; i < data.length; i++) {
    //     setState(() {
    //       fetchlcluclCMDData.add(data[i]);
    //     });
    //   }
    //   if (fetchlcluclCMDData.length >= 24) {
    //     breaking3(fetchlcluclCMDData);
    //   }
    // }
    if (data.isEmpty) {
      setState(() {
        valuechanged = dataa;
      });
    }
  }

  Future<void> sendinitialCmd() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    await _sendMessagee(manufacturerCMD);
    await Future.delayed(const Duration(seconds: 8), () {
      sendinitialCmdd();
    });
    await Future.delayed(const Duration(seconds: 8), () {
      sendlcluclCmdd();
    });
    setState(() {
      screenLoaded = true;
    });
    await Future.delayed(const Duration(seconds: 8), () {
      setState(() {
        ucllclFlag = false;
        stopFlag = false;
      });
      dataSend();
    });
  }

  Future<void> sendlcluclCmdd() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('LCL UCL:$ucllclFlag'),
    ));
    await _sendMessagee(upperlimitlowerTagCMD);
  }

  Future<void> sendinitialCmdd() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    await _sendMessagee(despritionTagCMD);
  }

  Future<void> dataSend() async {
    int i = 0;
    while (i < 1000) {
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
      await Future.delayed(const Duration(seconds: 1), () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(
        title: Text('HART'),
        centerTitle: true,
        actions: [
          _container.connecting(serverName, isConnected, isDisconnecting),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body:
          //screenLoaded == false ||
          //  (!isConnected)
          //     ? Center(
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             CircularProgressIndicator(),
          //             isConnected
          //                 ? Text('Initailizing......')
          //                 : Text('Please Check whether the Device is Connected or Not'),
          //           ],
          //         ),
          //       )
          //     :
          SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              deviceDetails(),
              Text('code of set tag $check1'),
              Text('Tag Command sent : $tagFinalCmd'),
              currentValueShow(),
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
                                        zerotrim(),
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          decoration: new BoxDecoration(color: Colors.blue[100]),
                                          child: Center(
                                            child: SizedBox(
                                              width: 200,
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) => StatefulBuilder(
                                                        builder: (context, setStateModal) {
                                                          return AlertDialog(
                                                            title: Text('Choose The Sensor Trimming'),
                                                            content: Container(
                                                              margin: EdgeInsets.all(5),
                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                              height: 200,
                                                              //  decoration: new BoxDecoration(color: Colors.blue[100]),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  lowertrim(),
                                                                  uppertrim(),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: [
                                                              ElevatedButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Text('Cancel'))
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text('Sensor Trimming')),
                                            ),
                                          ),
                                        ),
                                        outputtrim(),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'))
                                  ],
                                );
                              }));
                    },
                    child: Text('Trimming')),
              ),
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
                                    children: [
                                      Text("Setup Screen"),
                                    ],
                                  ),
                                  content: Container(
                                    width: MediaQuery.of(context).size.width * 1,
                                    height: MediaQuery.of(context).size.height * 0.15,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 1,
                                            height: 50,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) =>
                                                          StatefulBuilder(builder: (context, setStateModal) {
                                                            return AlertDialog(
                                                              title: Center(child: Text('Tag Setup')),
                                                              content: SingleChildScrollView(
                                                                  child: Column(children: [
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
                                                                    onChanged: (String tagCode) {
                                                                      temptagCode = codeConversation(tagCode);
                                                                    },
                                                                    keyboardType: TextInputType.text,
                                                                    style: TextStyle(
                                                                      fontSize: 20,
                                                                    ),
                                                                    decoration: InputDecoration(
                                                                      contentPadding:
                                                                          EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                                      border: const UnderlineInputBorder(),
                                                                      filled: true,
                                                                      hintText: 'Tag Name',
                                                                      hintStyle:
                                                                          TextStyle(color: Colors.grey, fontSize: 20),
                                                                      fillColor: Colors.pink[50],
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(30.0)),
                                                                        borderSide:
                                                                            BorderSide(color: Colors.grey, width: 2),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(30.0)),
                                                                        borderSide:
                                                                            BorderSide(color: Colors.transparent),
                                                                      ),
                                                                    ),
                                                                    onSaved: (value) {
                                                                      check1 = value!;

                                                                      //  final temp = codeConversation(tagCode);

                                                                      // setStateModal(() {
                                                                      //  tagFinalCmd = tagCMDFirst + temp + tagCMDSecond;
                                                                      // });
                                                                    },
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                setTagtestFlag && _formKey.currentState!.validate()
                                                                    ? Center(
                                                                        child: Container(
                                                                          margin:
                                                                              const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                                                          height: 50,
                                                                          width: 210,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.all(Radius.circular(20)),
                                                                              color: Colors.green),
                                                                          child: Center(
                                                                            child: Row(children: [
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text(
                                                                                'Tag Set Successfully',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                              Icon(Icons.check)
                                                                            ]),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
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
                                                                        if (_formKey.currentState!.validate()) {
                                                                          Navigator.of(context).pop();
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Text('SetTag')),
                                                              ])),
                                                            );
                                                          }));
                                                },
                                                child: Text("Set Tag")),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 3,
                                            height: 50,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) =>
                                                          StatefulBuilder(builder: (context, setStateModal) {
                                                            return AlertDialog(
                                                                title: Center(child: Text('Set LCL UCL')),
                                                                content: SingleChildScrollView(
                                                                    child: Column(children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context).size.width * 0.7,
                                                                    child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Center(child: Text('Select Unit')),
                                                                          SizedBox(
                                                                            width: 20,
                                                                          ),
                                                                          Center(
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors.amber[50]),
                                                                              padding: const EdgeInsets.all(0.0),
                                                                              width: 100,
                                                                              child: DropdownButton<String>(
                                                                                value: _chosenValue,
                                                                                style: TextStyle(color: Colors.black),
                                                                                items: unitsName
                                                                                    .map<DropdownMenuItem<String>>(
                                                                                        (String value) {
                                                                                  return DropdownMenuItem<String>(
                                                                                    value: value,
                                                                                    child: Text(value),
                                                                                  );
                                                                                }).toList(),
                                                                                hint: Flexible(
                                                                                  child: Text(
                                                                                    "choose unit",
                                                                                    style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                ),
                                                                                onChanged: (String? value) {
                                                                                  for (var unit in unitsModel) {
                                                                                    if (unit.name == value) {
                                                                                      uclCode = unit.ucl;
                                                                                      lclCode = unit.lcl;
                                                                                      id = unit.id;
                                                                                    }
                                                                                  }
                                                                                  final temp2 = Uint8List.fromList(
                                                                                      utf8.encode(lclCode));
                                                                                  final temp3 = Uint8List.fromList(
                                                                                      utf8.encode(uclCode));
                                                                                  uclController.text = uclCode;
                                                                                  lclController.text = lclCode;
                                                                                  _uclKey.currentState!.validate();
                                                                                  _lclKey.currentState!.validate();
                                                                                  setStateModal(() {
                                                                                    lclinput = temp2;
                                                                                    uclinput = temp3;
                                                                                    unitinput = [id];
                                                                                    ucllclFlag = true;
                                                                                    uclCode = uclCode;
                                                                                    lclCode = lclCode;
                                                                                    id = id;
                                                                                    _chosenValue = value;
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Form(
                                                                    key: _uclKey,
                                                                    child: Container(
                                                                      width: MediaQuery.of(context).size.width * 0.5,
                                                                      child: TextFormField(
                                                                        key: ValueKey('ucl'),
                                                                        validator: (value) {
                                                                          print(double.parse(value!));
                                                                          if (double.parse(value) <= 2000.0 &&
                                                                              double.parse(value) >= 0.0) {
                                                                            print(double.parse(value));
                                                                            return '';
                                                                          }
                                                                          return 'Enter UCL Value between 0 to 2000';
                                                                        },
                                                                        keyboardType: TextInputType.number,
                                                                        controller: uclController,
                                                                        onChanged: (String? value) {
                                                                          setState(() {
                                                                            isValidUCLLCL = false;
                                                                          });
                                                                          _uclValue = value!;
                                                                        },
                                                                        style: TextStyle(
                                                                          fontSize: 20,
                                                                        ),
                                                                        decoration: InputDecoration(
                                                                          errorText: ChatService.validateUcl(_uclValue)
                                                                              ? null
                                                                              : 'Enter the Value',
                                                                          contentPadding:
                                                                              EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                                          border: const UnderlineInputBorder(),
                                                                          filled: true,
                                                                          hintText: 'UCL value',
                                                                          hintStyle: TextStyle(
                                                                              color: Colors.grey, fontSize: 20),
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors.grey, width: 2),
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: Colors.transparent),
                                                                          ),
                                                                        ),
                                                                        onSaved: (value) {
                                                                          uclCode = value!;
                                                                          final temp =
                                                                              Uint8List.fromList(utf8.encode(uclCode));
                                                                          setStateModal(() {
                                                                            uclCode = uclCode;
                                                                            uclinput = temp;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Form(
                                                                    key: _lclKey,
                                                                    child: Container(
                                                                      width: MediaQuery.of(context).size.width * 0.5,
                                                                      child: TextFormField(
                                                                        key: ValueKey('lcl'),
                                                                        validator: (value) {
                                                                          print(double.parse(value!));
                                                                          if (double.parse(value) <= 2000.0 &&
                                                                              double.parse(value) >= 0.0) {
                                                                            print(double.parse(value));
                                                                            return '';
                                                                          }
                                                                          return 'Enter LCL Value between 0 to 2000';
                                                                        },
                                                                        keyboardType: TextInputType.number,
                                                                        controller: lclController,
                                                                        onChanged: (String? value) {
                                                                          setState(() {
                                                                            isValidUCLLCL = false;
                                                                          });

                                                                          _lclValue = value!;
                                                                        },
                                                                        style: TextStyle(
                                                                          fontSize: 20,
                                                                        ),
                                                                        decoration: InputDecoration(
                                                                          errorText: ChatService.validatelcl(_lclValue)
                                                                              ? null
                                                                              : 'Enter the Value',
                                                                          contentPadding:
                                                                              EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                                          border: const UnderlineInputBorder(),
                                                                          filled: true,
                                                                          hintText: 'LCL value',
                                                                          hintStyle: TextStyle(
                                                                              color: Colors.grey, fontSize: 20),
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors.grey, width: 2),
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: Colors.transparent),
                                                                          ),
                                                                        ),
                                                                        onSaved: (value) {
                                                                          lclCode = value!;
                                                                          final temp =
                                                                              Uint8List.fromList(utf8.encode(lclCode));
                                                                          setStateModal(() {
                                                                            lclCode = lclCode;
                                                                            lclinput = temp;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  ElevatedButton(
                                                                      onPressed: () {
                                                                        setStateModal(() {
                                                                          setUcltestFlag = true;
                                                                        });
                                                                        _submitForm3();
                                                                        Future.delayed(const Duration(seconds: 4), () {
                                                                          setStateModal(() {
                                                                            setUcltestFlag = false;
                                                                          });
                                                                          if (lclCode.isEmpty && uclCode.isEmpty) {
                                                                            Navigator.of(context).pop();
                                                                          }
                                                                        });
                                                                      },
                                                                      child: Text('SET UCL & LCL')),
                                                                  setUcltestFlag && isValidUCLLCL
                                                                      ? Center(
                                                                          child: Container(
                                                                            margin: const EdgeInsets.fromLTRB(
                                                                                10, 10, 0, 10),
                                                                            height: 50,
                                                                            width: 210,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.all(
                                                                                    Radius.circular(20)),
                                                                                color: Colors.green),
                                                                            child: Center(
                                                                              child: Row(children: [
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Text(
                                                                                  'UCL LCL Set Successfully',
                                                                                  style: TextStyle(
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                ),
                                                                                Icon(Icons.check)
                                                                              ]),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                ])));
                                                          }));
                                                },
                                                child: Text("Set LCL UCL")),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
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
                    child: Text('Setup')),
              ),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Loop Test',
                                        style: TextStyle(fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
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
                                              keyboardType: TextInputType.number,
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
                                                loopCode = double.parse(value!);
                                                List<int> myList =
                                                    Float32List.fromList([loopCode]).buffer.asUint8List();
                                                List<int> bytes = new List.from(myList.reversed);

                                                setState(() {
                                                  loopFinalCmd = loopCMDFirst + bytes + loopCMDSecond;
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
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text('Loop Test')),
                                        looptestFlag && isValidLoop
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
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      fetchlcluclCMD = true;
                    });
                    _sendMessagee(refreshCmd);
                    await Future.delayed(const Duration(seconds: 5), () {
                      setState(() {
                        fetchlcluclCMD = false;
                      });
                    });
                  },
                  child: Text('Refresh'))
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
            'Refresh Current Value',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          onPressed: () async {
            dataSend();
          }),
    );
  }

  Widget currentValueShow() {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 10, 20),
        height: MediaQuery.of(context).size.height * 0.2,
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
          ],
        ));
  }

//conversion Code
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

  void breaking3(dynamic data) {
    var reverseValue = isSubArray(
        data,
        [
          0x0,
          0x0,
          0x0,
          0x0,
        ],
        9);
    // = reverseCMD.sublist(1, 9);
    unitsnamee = reverseValue[0];
    for (var unit in unitsModel) {
      if (unit.id == unitsnamee) {
        unitNamedValue = unit.name;
      }
    }
    List<dynamic> upperValue = reverseValue.sublist(1, 5);
    List<dynamic> lowerValue = reverseValue.sublist(5, 9);
    var upperValueUCL = _service.convertion(upperValue);
    var lowerValueUCL = _service.convertion(lowerValue);
    setState(() {
      uCLVALUE = upperValueUCL;
      lCLVALUE = lowerValueUCL;
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

//form submittion
  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      tagFinalCmd = tagCMDFirst + temptagCode + tagCMDSecond;
      _sendMessagee(tagFinalCmd);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Enter Valid Tag Name'),
      ));
    }
  }

  void _submitForm2() async {
    isValidLoop = _loopKey.currentState!.validate();
    if (isValidLoop) {
      _loopKey.currentState!.save();
      _sendMessagee(loopFinalCmd);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Enter Valid Current Input'),
      ));
    }
  }

  void _submitForm3() async {
    isValidUCLLCL = ChatService.validatelcl(_lclValue) && ChatService.validateUcl(_uclValue);
    _uclKey.currentState!.validate();
    _lclKey.currentState!.validate();
    if (isValidUCLLCL) {
      _uclKey.currentState!.save();
      setState(() {
        ucllclFlag = true;
      });
      List<int> cmdforlclucl = Command.lcluclCmd1 + unitinput + uclinput + lclinput + Command.lcluclCmd2;
      _sendMessagee(cmdforlclucl);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('UCL LCL Set'),
      ));
      await Future.delayed(const Duration(seconds: 8), () {
        setState(() {
          ucllclFlag = false;
        });
      });
      //
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Enter Valid LCL and UCL Name'),
      ));
    }
  }

//Device Details

  Widget deviceDetails() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      color: Colors.grey[200],
      child: Column(
        children: [
     
          Row(
            children: [
              Flexible(child: Text('Manufacturer Name Int Value:')),
              Flexible(
              
                  child:isSubArray(isSubArray(manufacture, macaddress, 10), [254], 1).first==55? Text(
                'YOKOGOWA',
                style: TextStyle(
                  fontSize: 10,
                ),
              ):Text('Others'))
            ],
          ),
          Row(
            children: [
              Flexible(child: Text('Tag Name:')),
              Flexible(
                  child: Text(
                '${isSubArray(tag, macaddress, 10).sublist(4,10)}',
                style: TextStyle(
                  fontSize: 5,
                ),
              ))
            ],
          ),
          Row(
            children: [
              Text('Lcl Name:'), //lCLVALUE != 0.0 ?
              Text('$lCLVALUE')
              //: Text('Not Yet Fetched')
            ],
          ),
          Row(
            children: [
              Text('Ucl Name:'),
              // uCLVALUE != 0.0 ?
              Text('$uCLVALUE')
              //: Text('Not Yet Fetched')
            ],
          ),
          Row(
            children: [
              Text('Units Name:'),
              //unitsnamee != 0 ?
              Text(unitNamedValue)
              // : Text('Not Yet Fetched')
            ],
          ),
        ],
      ),
    );
  }
//Trimming Widgets______________________________________________________________________________________
//______________________________________________________________________________________________________
//______________________________________________________________________________________________________
//Zero Trimming, Upper Trimming , Lower Trimming , OutputTrimming Widgets are below.

//Zero Triming Widget
  Widget zerotrim() {
    return Container(
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: new BoxDecoration(color: Colors.blue[100]),
      child: Center(
        child: SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Zero Trimming"),
                  content: Text("Please Tap on below button to complete Zero Trimming"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          stopFlag = true;
                        });
                        await _sendMessagee(zeroTrim);

                        await Future.delayed(const Duration(seconds: 3), () {
                          setState(() {
                            stopFlag = false;
                          });
                        });
                        outer = false;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Zero Trimming"),
                    ),
                  ],
                ),
              );
            },
            child: Text("Zero Trimming"),
          ),
        ),
      ),
    );
  }

//Upper Triming Widget
  Widget uppertrim() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: EdgeInsets.all(5),
      decoration: new BoxDecoration(color: Colors.blue[100]),
      child: Center(
        child: SizedBox(
          width: 200,
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
                    content: Form(
                      key: _highKey,
                      child: TextFormField(
                        key: ValueKey('low'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid pressure Name';
                          }
                          return 'null';
                        },
                        keyboardType: TextInputType.number,
                        initialValue: '2000',
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            stopFlag = true;
                          });
                          _highKey.currentState!.save();
                          await _sendMessagee(higherCMD);
                          await Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              stopFlag = false;
                            });
                          });

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
                          await Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              stopFlag = false;
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
            child: Text("Up Trimming"),
          ),
        ),
      ),
    );
  }

//Lower Triming Widget
  Widget lowertrim() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: EdgeInsets.all(5),
      decoration: new BoxDecoration(color: Colors.blue[100]),
      child: Center(
        child: SizedBox(
          width: 200,
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
                    content: Form(
                      key: _lowKey,
                      child: TextFormField(
                        key: ValueKey('low'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid pressure Name';
                          }
                          return 'null';
                        },
                        keyboardType: TextInputType.number,
                        initialValue: '0',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                          border: const UnderlineInputBorder(),
                          filled: true,
                          hintText: 'Enter value',
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
                          print(value);
                        },
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            stopFlag = true;
                          });
                          _lowKey.currentState!.save();
                          await _sendMessagee(lowerCMD);
                          await Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              stopFlag = false;
                            });
                          });

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
                          await Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              stopFlag = false;
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
            child: Text("Low Trimming"),
          ),
        ),
      ),
    );
  }

//Output Triming Widget
  Widget outputtrim() {
    return Container(
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: new BoxDecoration(color: Colors.blue[100]),
      child: Center(
        child: SizedBox(
          width: 200,
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
                  content: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '4.0',
                  ),
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
                        setState(() {
                          stopFlag = true;
                        });
                        await _sendMessagee(outerHighCMD);
                        await Future.delayed(const Duration(seconds: 3), () {
                          setState(() {
                            stopFlag = false;
                          });
                        });

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
                  content: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '20.0',
                  ),
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
                        await Future.delayed(const Duration(seconds: 3), () {
                          setState(() {
                            stopFlag = false;
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
            child: Text("Output Trimming"),
          ),
        ),
      ),
    );
  }
}
