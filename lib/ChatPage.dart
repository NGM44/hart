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
  List<int> cmdforlclucl = [];

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
    manufacturerCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.manufacturerCMD +
        [0x0D, 0x0A];
    despritionTagCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.despritionTagCMD +
        [0x0D, 0x0A];
    upperlimitlowerTagCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.upperlimitlowerTagCMD +
        [0x0D, 0x0A];
    processCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.processCMD +
        [0x0D, 0x0A];
    currentCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.currentCMD +
        [0x0D, 0x0A];

    tagCMDFirst =
        [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.tagCMDFirst;
    tagCMDSecond = Command.tagCMDSecond + [0x0D, 0x0A];

    loopCMDFirst =
        [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.loopFirst;
    loopCMDSecond = Command.loopSecond + [0x0D, 0x0A];

    higherCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.higherCMD +
        [0x0D, 0x0A];

    lowerCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.lowerCMD +
        [0x0D, 0x0A];
    outerHighCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.outerHighCMD +
        [0x0D, 0x0A];
    outerLowCMD = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.outerLowCMD +
        [0x0D, 0x0A];

    zeroTrim = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.zeroTrimCmd +
        [0x0D, 0x0A];

    lcluclCmd = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.lcluclCmd +
        [0x0D, 0x0A];

    lcluclCmd1 =
        [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] + macaddress + Command.lcluclCmd1;
    lcluclCmd2 = Command.lcluclCmd2 + [0x0D, 0x0A];

    refreshCmd = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82] +
        macaddress +
        Command.FetchlcluclCMD +
        [0x0D, 0x0A];

    sendinitialCmd();
  }

  @override
  void initState() {
    macaddress = [0xB7, 0x04, 0x2D, 0xAD, 0xCF];
    //numberConvert(widget.server.address);

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
    print(
        '----------------------------------------------------------------------------');
    print('Command Sent : $text');
    print(
        '----------------------------------------------------------------------------');
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
        for (int i = 0; i < data.length; i++) {
          setState(() {
            fetchlcluclCMDData.add(data[i]);
          });
        }

        if (fetchlcluclCMDData.length >= 24) {
          breaking3(
            isSubArray(fetchlcluclCMDData, macaddress, 21),
          );
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
        screenLoaded = true;
        ucllclFlag = false;
        stopFlag = false;
      });
      dataSend();
    });
  }

  Future<void> sendlcluclCmdd() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    await _sendMessagee(upperlimitlowerTagCMD);
  }

  Future<void> sendinitialCmdd() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    await _sendMessagee(despritionTagCMD);
  }

  void fetchTag() {
    tag = [];
    tagDesp = true;
    // _sendMessagee(dataaa);
    _sendMessagee(despritionTagCMD);
  }

  void fetchlcl() async {
    fetchlcluclCMDData = [];
    ucllclFlag = true;
    // _sendMessagee(dataaa);
    _sendMessagee(upperlimitlowerTagCMD);
    await Future.delayed(const Duration(seconds: 8), () {
      setState(() {
        ucllclFlag = false;
      });
    });
  }

  Future<void> dataSend() async {
    int i = 0;
    while (i < 1000) {
      i = i + 1;
      if (!stopFlag && !ucllclFlag) {
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
      await Future.delayed(const Duration(seconds: 2), () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final serverName = widget.server.name ?? "Unknown";
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(),
                  _container.connecting(
                      serverName, isConnected, isDisconnecting)
                ],
              ),

              //  Container(
              //     child: Column(children: [
              //       Text("Loading Dashboard........")
              //     ]),
              //   ),
              deviceDetails(),
              //  Text('command :$cmdforlclucl'),
              currentValueShow(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [
                    GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder:
                                  (BuildContext context) => StatefulBuilder(
                                          builder: (context, setStateModal) {
                                        return AlertDialog(
                                          title: Text('Choose The Trimming'),
                                          content: Container(
                                            width: 300,
                                            height: 150,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                zerotrim(),
                                                Center(
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: ElevatedButton(
                                                        onPressed: () async {
                                                          await showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                StatefulBuilder(
                                                              builder: (context,
                                                                  setStateModal) {
                                                                return AlertDialog(
                                                                  title: Center(
                                                                    child: Text(
                                                                        'Choose The Sensor Trimming'),
                                                                  ),
                                                                  content:
                                                                      Container(
                                                                    margin: EdgeInsets
                                                                        .all(5),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.5,
                                                                    height: 110,
                                                                    //  decoration: new BoxDecoration(color: Colors.blue[100]),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        lowertrim(),
                                                                        uppertrim(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            'Cancel'))
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                            'Sensor Trimming')),
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
                        child: Image.asset(
                          'assets/cutting.png',
                          width: 60,
                          height: 60,
                        )),
                    Text(
                      'Trimming',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    )
                  ]),
                  Column(children: [
                    GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder:
                                  (BuildContext context) => StatefulBuilder(
                                          builder: (context, setStateModal) {
                                        return AlertDialog(
                                          title: Column(
                                            children: [
                                              Text("Setup Screen"),
                                            ],
                                          ),
                                          content: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    height: 50,
                                                    child: ElevatedButton(
                                                        onPressed: () async {
                                                          await showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  StatefulBuilder(
                                                                      builder:
                                                                          (context,
                                                                              setStateModal) {
                                                                    return AlertDialog(
                                                                      title: Center(
                                                                          child:
                                                                              Text('Tag Setup')),
                                                                      content:
                                                                          SingleChildScrollView(
                                                                              child: Column(children: [
                                                                        Form(
                                                                          key:
                                                                              _formKey,
                                                                          child:
                                                                              TextFormField(
                                                                            key:
                                                                                ValueKey('tag'),
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return 'Please enter a valid TAG Name';
                                                                              }
                                                                              return null;
                                                                            },
                                                                            onChanged:
                                                                                (String tagCode) {
                                                                              check1 = tagCode;
                                                                            },
                                                                            keyboardType:
                                                                                TextInputType.text,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 20,
                                                                            ),
                                                                            decoration:
                                                                                InputDecoration(
                                                                              contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                                              border: const UnderlineInputBorder(),
                                                                              filled: true,
                                                                              hintText: 'Tag Name',
                                                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                                                              fillColor: Colors.white,
                                                                              // enabledBorder: OutlineInputBorder(
                                                                              //   borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                                              //   borderSide: BorderSide(color: Colors.grey, width: 2),
                                                                              // ),
                                                                              // focusedBorder: OutlineInputBorder(
                                                                              //   borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                                              //   borderSide: BorderSide(color: Colors.transparent),
                                                                              // ),
                                                                            ),
                                                                            onSaved:
                                                                                (value) {
                                                                              check1 = value!;

                                                                              //  final temp = codeConversation(tagCode);

                                                                              // setStateModal(() {
                                                                              //  tagFinalCmd = tagCMDFirst + temp + tagCMDSecond;
                                                                              // });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        setTagtestFlag //&& _formKey.currentState!.validate()
                                                                            ? Center(
                                                                                child: Container(
                                                                                  margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                                                                  height: 50,
                                                                                  width: 210,
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.green),
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
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Container(),
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
                                                                          ],
                                                                        ),
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
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            3,
                                                    height: 50,
                                                    child: ElevatedButton(
                                                        onPressed: () async {
                                                          await showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  StatefulBuilder(
                                                                      builder:
                                                                          (context,
                                                                              setStateModal) {
                                                                    return AlertDialog(
                                                                        title: Center(
                                                                            child:
                                                                                Text('Set Lower & Higher Range')),
                                                                        content: SingleChildScrollView(
                                                                            child: Column(children: [
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.7,
                                                                            child:
                                                                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                              Center(child: Text('Select Unit')),
                                                                              SizedBox(
                                                                                width: 20,
                                                                              ),
                                                                              Container(
                                                                                decoration: BoxDecoration(color: Colors.white),
                                                                                padding: const EdgeInsets.all(0.0),
                                                                                width: 100,
                                                                                child: DropdownButton<String>(
                                                                                  value: _chosenValue,
                                                                                  style: TextStyle(color: Colors.black),
                                                                                  items: unitsName.map<DropdownMenuItem<String>>((String value) {
                                                                                    return DropdownMenuItem<String>(
                                                                                      value: value,
                                                                                      child: Text(value),
                                                                                    );
                                                                                  }).toList(),
                                                                                  hint: Text(
                                                                                    "choose unit",
                                                                                    style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                  onChanged: (String? value) {
                                                                                    for (var unit in unitsModel) {
                                                                                      if (unit.name == value) {
                                                                                        uclCode = unit.ucl;
                                                                                        lclCode = unit.lcl;
                                                                                        id = unit.id;
                                                                                      }
                                                                                    }
                                                                                    final temp2 =getNumConversation(lclCode);
                                                                                    final temp3 =getNumConversation(uclCode);
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
                                                                            ]),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Form(
                                                                            key:
                                                                                _uclKey,
                                                                            child:
                                                                                Container(
                                                                              width: MediaQuery.of(context).size.width * 0.5,
                                                                              child: TextFormField(
                                                                                key: ValueKey('ucl'),
                                                                                validator: (value) {
                                                                                  print(double.parse(value!));
                                                                                  if (double.parse(value) <= 2000.0 && double.parse(value) >= 0.0) {
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
                                                                                  fillColor: Colors.white,
                                                                                  errorText: ChatService.validateUcl(_uclValue) ? null : 'Enter the Value',
                                                                                  contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                                                  border: const UnderlineInputBorder(),
                                                                                  filled: true,
                                                                                  hintText: 'Upper range value',
                                                                                  hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                                                                  //  enabledBorder: OutlineInputBorder(
                                                                                  //   borderSide: BorderSide(color: Colors.grey, width: 2),
                                                                                  // ),

                                                                                  // focusedBorder: OutlineInputBorder(
                                                                                  //   borderSide: BorderSide(color: Colors.transparent),
                                                                                  // ),
                                                                                ),
                                                                                onSaved: (value) {
                                                                                  uclCode = value!;
                                                                                    final temp =   getNumConversation(value);
                                                                                 // final temp = Uint8List.fromList(utf8.encode(uclCode));
                                                                                  setStateModal(() {
                                                                                    uclCode = uclCode;
                                                                                    uclinput = temp;
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Form(
                                                                            key:
                                                                                _lclKey,
                                                                            child:
                                                                                Container(
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
                                                                                  setState(() {
                                                                                    isValidUCLLCL = false;
                                                                                  });

                                                                                  _lclValue = value!;
                                                                                },
                                                                                style: TextStyle(
                                                                                  fontSize: 20,
                                                                                ),
                                                                                decoration: InputDecoration(
                                                                                  fillColor: Colors.white,
                                                                                  errorText: ChatService.validatelcl(_lclValue) ? null : 'Enter the Value',
                                                                                  contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                                                  border: const UnderlineInputBorder(),
                                                                                  filled: true,
                                                                                  hintText: 'Lower Range value',
                                                                                  hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                                                                  // enabledBorder: OutlineInputBorder(
                                                                                  //   borderSide: BorderSide(color: Colors.grey, width: 2),
                                                                                  // ),
                                                                                  // focusedBorder: OutlineInputBorder(
                                                                                  //   borderSide: BorderSide(color: Colors.transparent),
                                                                                  // ),
                                                                                ),
                                                                                onSaved: (value) {
                                                                                  lclCode = value!;
                                                                                  final temp = Uint8List.fromList(utf8.encode(lclCode));
                                                                                  setStateModal(() {
                                                                                    lclCode = lclCode;
                                                                                    lclinput = temp;
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(),
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
                                                                                  child: Text('SET Lower & Upper Range')),
                                                                            ],
                                                                          ),
                                                                          setUcltestFlag && isValidUCLLCL
                                                                              ? Center(
                                                                                  child: Container(
                                                                                    margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                                                                    height: 50,
                                                                                    width: 210,
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.green),
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
                                                        child: Text(
                                                            "Set Lower & Upper Range")),
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
                        child: Image.asset(
                          'assets/setup.png',
                          width: 60,
                          height: 60,
                        )),
                    Text(
                      'Setup',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    )
                  ]),
                  Column(children: [
                    GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  StatefulBuilder(
                                      builder: (context, setStateModal) {
                                    return AlertDialog(
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Loop Test',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              'Enter the Current value in mA.'),
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: TextFormField(
                                                  key: ValueKey('loopKey'),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter Current value';
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            30, 30, 30, 8),
                                                    border:
                                                        const UnderlineInputBorder(),
                                                    filled: true,
                                                    hintText:
                                                        'Loop Test Current value',
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 20),
                                                    fillColor: Colors.white,
                                                    // enabledBorder:
                                                    //     OutlineInputBorder(
                                                    //   borderRadius:
                                                    //       BorderRadius.all(
                                                    //           Radius.circular(
                                                    //               30.0)),
                                                    //   borderSide: BorderSide(
                                                    //       color: Colors.grey,
                                                    //       width: 2),
                                                    // ),
                                                    // focusedBorder:
                                                    //     OutlineInputBorder(
                                                    //   borderRadius:
                                                    //       BorderRadius.all(
                                                    //           Radius.circular(
                                                    //               30.0)),
                                                    //   borderSide: BorderSide(
                                                    //       color: Colors
                                                    //           .transparent),
                                                    // ),
                                                  ),
                                                  onSaved: (value) {
                                                    List<int> bytes =
                                                        getNumConversation(
                                                            value ?? '');
                                                    setState(() {
                                                      loopFinalCmd =
                                                          loopCMDFirst +
                                                              bytes +
                                                              loopCMDSecond;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      setStateModal(() {
                                                        looptestFlag = true;
                                                      });
                                                      _submitForm2();
                                                      Future.delayed(
                                                          const Duration(
                                                              seconds: 4), () {
                                                        setStateModal(() {
                                                          looptestFlag = false;
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: Text('Loop Test')),
                                              ],
                                            ),
                                            looptestFlag && isValidLoop
                                                ? Center(
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 10, 0, 10),
                                                      height: 50,
                                                      // alignment: AlignmentGeometry.lerp(0, , t),
                                                      width: 210,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
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
                        child: Image.asset(
                          'assets/loop.png',
                          width: 60,
                          height: 60,
                        )),
                    Text(
                      'Loop Test',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    )
                  ]),
                ],
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.8,
              //   height: 60.0,
              //   child: ElevatedButton(
              //       onPressed: () async {
              //         await showDialog(
              //             context: context,
              //             builder: (BuildContext context) => StatefulBuilder(
              //                     builder: (context, setStateModal) {
              //                   return AlertDialog(
              //                     title: Text('Choose The Trimming'),
              //                     content: Container(
              //                       width: 300,
              //                       height: 200,
              //                       child: Column(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.start,
              //                         children: [
              //                           zerotrim(),
              //                           Container(
              //                             margin: EdgeInsets.all(5),
              //                             width: MediaQuery.of(context)
              //                                     .size
              //                                     .width *
              //                                 0.5,
              //                             decoration: new BoxDecoration(
              //                                 color: Colors.blue[100]),
              //                             child: Center(
              //                               child: SizedBox(
              //                                 width: 200,
              //                                 child: ElevatedButton(
              //                                     onPressed: () async {
              //                                       await showDialog(
              //                                         context: context,
              //                                         builder: (BuildContext
              //                                                 context) =>
              //                                             StatefulBuilder(
              //                                           builder: (context,
              //                                               setStateModal) {
              //                                             return AlertDialog(
              //                                               title: Text(
              //                                                   'Choose The Sensor Trimming'),
              //                                               content: Container(
              //                                                 margin: EdgeInsets
              //                                                     .all(5),
              //                                                 width: MediaQuery.of(
              //                                                             context)
              //                                                         .size
              //                                                         .width *
              //                                                     0.5,
              //                                                 height: 200,
              //                                                 //  decoration: new BoxDecoration(color: Colors.blue[100]),
              //                                                 child: Column(
              //                                                   mainAxisAlignment:
              //                                                       MainAxisAlignment
              //                                                           .start,
              //                                                   children: [
              //                                                     lowertrim(),
              //                                                     uppertrim(),
              //                                                   ],
              //                                                 ),
              //                                               ),
              //                                               actions: [
              //                                                 ElevatedButton(
              //                                                     onPressed:
              //                                                         () {
              //                                                       Navigator.of(
              //                                                               context)
              //                                                           .pop();
              //                                                     },
              //                                                     child: Text(
              //                                                         'Cancel'))
              //                                               ],
              //                                             );
              //                                           },
              //                                         ),
              //                                       );
              //                                     },
              //                                     child:
              //                                         Text('Sensor Trimming')),
              //                               ),
              //                             ),
              //                           ),
              //                           outputtrim(),
              //                         ],
              //                       ),
              //                     ),
              //                     actions: [
              //                       ElevatedButton(
              //                           onPressed: () {
              //                             Navigator.of(context).pop();
              //                           },
              //                           child: Text('Cancel'))
              //                     ],
              //                   );
              //                 }));
              //       },
              //       child: Text('Trimming')),
              // ),

              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.8,
              //   height: 60.0,
              //   child: ElevatedButton(
              // onPressed: () async {
              //   await showDialog(
              //       context: context,
              //       builder: (BuildContext context) => StatefulBuilder(
              //               builder: (context, setStateModal) {
              //             return AlertDialog(
              //               title: Column(
              //                 children: [
              //                   Text("Setup Screen"),
              //                 ],
              //               ),
              //               content: Container(
              //                 width:
              //                     MediaQuery.of(context).size.width * 1,
              //                 height: MediaQuery.of(context).size.height *
              //                     0.15,
              //                 child: SingleChildScrollView(
              //                   child: Column(
              //                     children: [
              //                       SizedBox(
              //                         width: MediaQuery.of(context)
              //                                 .size
              //                                 .width *
              //                             1,
              //                         height: 50,
              //                         child: ElevatedButton(
              //                             onPressed: () async {
              //                               await showDialog(
              //                                   context: context,
              //                                   builder: (BuildContext
              //                                           context) =>
              //                                       StatefulBuilder(
              //                                           builder: (context,
              //                                               setStateModal) {
              //                                         return AlertDialog(
              //                                           title: Center(
              //                                               child: Text(
              //                                                   'Tag Setup')),
              //                                           content:
              //                                               SingleChildScrollView(
              //                                                   child: Column(
              //                                                       children: [
              //                                                 Form(
              //                                                   key:
              //                                                       _formKey,
              //                                                   child:
              //                                                       TextFormField(
              //                                                     key: ValueKey(
              //                                                         'tag'),
              //                                                     validator:
              //                                                         (value) {
              //                                                       if (value!
              //                                                           .isEmpty) {
              //                                                         return 'Please enter a valid TAG Name';
              //                                                       }
              //                                                       return null;
              //                                                     },
              //                                                     onChanged:
              //                                                         (String
              //                                                             tagCode) {
              //                                                       check1 =
              //                                                           tagCode;
              //                                                     },
              //                                                     keyboardType:
              //                                                         TextInputType.text,
              //                                                     style:
              //                                                         TextStyle(
              //                                                       fontSize:
              //                                                           20,
              //                                                     ),
              //                                                     decoration:
              //                                                         InputDecoration(
              //                                                       contentPadding: EdgeInsets.fromLTRB(
              //                                                           30,
              //                                                           30,
              //                                                           30,
              //                                                           8),
              //                                                       border:
              //                                                           const UnderlineInputBorder(),
              //                                                       filled:
              //                                                           true,
              //                                                       hintText:
              //                                                           'Tag Name',
              //                                                       hintStyle: TextStyle(
              //                                                           color: Colors.grey,
              //                                                           fontSize: 20),
              //                                                       fillColor:
              //                                                           Colors.pink[50],
              //                                                       enabledBorder:
              //                                                           OutlineInputBorder(
              //                                                         borderRadius:
              //                                                             BorderRadius.all(Radius.circular(30.0)),
              //                                                         borderSide:
              //                                                             BorderSide(color: Colors.grey, width: 2),
              //                                                       ),
              //                                                       focusedBorder:
              //                                                           OutlineInputBorder(
              //                                                         borderRadius:
              //                                                             BorderRadius.all(Radius.circular(30.0)),
              //                                                         borderSide:
              //                                                             BorderSide(color: Colors.transparent),
              //                                                       ),
              //                                                     ),
              //                                                     onSaved:
              //                                                         (value) {
              //                                                       check1 =
              //                                                           value!;

              //                                                       //  final temp = codeConversation(tagCode);

              //                                                       // setStateModal(() {
              //                                                       //  tagFinalCmd = tagCMDFirst + temp + tagCMDSecond;
              //                                                       // });
              //                                                     },
              //                                                   ),
              //                                                 ),
              //                                                 SizedBox(
              //                                                   height:
              //                                                       10,
              //                                                 ),
              //                                                 setTagtestFlag
              //                                                     ? Center(
              //                                                         child:
              //                                                             Container(
              //                                                           margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              //                                                           height: 50,
              //                                                           width: 210,
              //                                                           decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.green),
              //                                                           child: Center(
              //                                                             child: Row(children: [
              //                                                               SizedBox(
              //                                                                 width: 10,
              //                                                               ),
              //                                                               Text(
              //                                                                 'Tag Set Successfully',
              //                                                                 style: TextStyle(
              //                                                                   fontSize: 14,
              //                                                                 ),
              //                                                               ),
              //                                                               Icon(Icons.check)
              //                                                             ]),
              //                                                           ),
              //                                                         ),
              //                                                       )
              //                                                     : Container(),
              //                                                 SizedBox(
              //                                                   height:
              //                                                       20,
              //                                                 ),
              //                                                 ElevatedButton(
              //                                                     onPressed:
              //                                                         () {
              //                                                       setStateModal(
              //                                                           () {
              //                                                         setTagtestFlag =
              //                                                             true;
              //                                                       });
              //                                                       _submitForm();
              //                                                       Future.delayed(
              //                                                           const Duration(seconds: 4),
              //                                                           () {
              //                                                         setStateModal(() {
              //                                                           setTagtestFlag = false;
              //                                                         });
              //                                                         if (_formKey.currentState!.validate()) {
              //                                                           Navigator.of(context).pop();
              //                                                         }
              //                                                       });
              //                                                     },
              //                                                     child: Text(
              //                                                         'SetTag')),
              //                                               ])),
              //                                         );
              //                                       }));
              //                             },
              //                             child: Text("Set Tag")),
              //                       ),
              //                       SizedBox(
              //                         height: 10,
              //                       ),
              //                       SizedBox(
              //                         width: MediaQuery.of(context)
              //                                 .size
              //                                 .width *
              //                             3,
              //                         height: 50,
              //                         child: ElevatedButton(
              //                             onPressed: () async {
              //                               await showDialog(
              //                                   context: context,
              //                                   builder: (BuildContext
              //                                           context) =>
              //                                       StatefulBuilder(
              //                                           builder: (context,
              //                                               setStateModal) {
              //                                         return AlertDialog(
              //                                             title: Center(
              //                                                 child: Text(
              //                                                     'Set LCL UCL')),
              //                                             content:
              //                                                 SingleChildScrollView(
              //                                                     child: Column(
              //                                                         children: [
              //                                                   SizedBox(
              //                                                     height:
              //                                                         10,
              //                                                   ),
              //                                                   Container(
              //                                                     width: MediaQuery.of(context).size.width *
              //                                                         0.7,
              //                                                     child: Row(
              //                                                         mainAxisAlignment:
              //                                                             MainAxisAlignment.center,
              //                                                         children: [
              //                                                           Center(child: Text('Select Unit')),
              //                                                           SizedBox(
              //                                                             width: 20,
              //                                                           ),
              //                                                           Center(
              //                                                             child: Container(
              //                                                               decoration: BoxDecoration(color: Colors.amber[50]),
              //                                                               padding: const EdgeInsets.all(0.0),
              //                                                               width: 100,
              //                                                               child: DropdownButton<String>(
              //                                                                 value: _chosenValue,
              //                                                                 style: TextStyle(color: Colors.black),
              //                                                                 items: unitsName.map<DropdownMenuItem<String>>((String value) {
              //                                                                   return DropdownMenuItem<String>(
              //                                                                     value: value,
              //                                                                     child: Text(value),
              //                                                                   );
              //                                                                 }).toList(),
              //                                                                 hint: Flexible(
              //                                                                   child: Text(
              //                                                                     "choose unit",
              //                                                                     style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
              //                                                                   ),
              //                                                                 ),
              //                                                                 onChanged: (String? value) {
              //                                                                   for (var unit in unitsModel) {
              //                                                                     if (unit.name == value) {
              //                                                                       uclCode = unit.ucl;
              //                                                                       lclCode = unit.lcl;
              //                                                                       id = unit.id;
              //                                                                     }
              //                                                                   }
              //                                                                   final temp2 = Uint8List.fromList(utf8.encode(lclCode));
              //                                                                   final temp3 = Uint8List.fromList(utf8.encode(uclCode));
              //                                                                   uclController.text = uclCode;
              //                                                                   lclController.text = lclCode;
              //                                                                   _uclKey.currentState!.validate();
              //                                                                   _lclKey.currentState!.validate();
              //                                                                   setStateModal(() {
              //                                                                     lclinput = temp2;
              //                                                                     uclinput = temp3;
              //                                                                     unitinput = [id];
              //                                                                     ucllclFlag = true;
              //                                                                     uclCode = uclCode;
              //                                                                     lclCode = lclCode;
              //                                                                     id = id;
              //                                                                     _chosenValue = value;
              //                                                                   });
              //                                                                 },
              //                                                               ),
              //                                                             ),
              //                                                           )
              //                                                         ]),
              //                                                   ),
              //                                                   SizedBox(
              //                                                     height:
              //                                                         10,
              //                                                   ),
              //                                                   Form(
              //                                                     key:
              //                                                         _uclKey,
              //                                                     child:
              //                                                         Container(
              //                                                       width:
              //                                                           MediaQuery.of(context).size.width * 0.5,
              //                                                       child:
              //                                                           TextFormField(
              //                                                         key:
              //                                                             ValueKey('ucl'),
              //                                                         validator:
              //                                                             (value) {
              //                                                           print(double.parse(value!));
              //                                                           if (double.parse(value) <= 2000.0 && double.parse(value) >= 0.0) {
              //                                                             print(double.parse(value));
              //                                                             return '';
              //                                                           }
              //                                                           return 'Enter UCL Value between 0 to 2000';
              //                                                         },
              //                                                         keyboardType:
              //                                                             TextInputType.number,
              //                                                         controller:
              //                                                             uclController,
              //                                                         onChanged:
              //                                                             (String? value) {
              //                                                           setState(() {
              //                                                             isValidUCLLCL = false;
              //                                                           });
              //                                                           _uclValue = value!;
              //                                                         },
              //                                                         style:
              //                                                             TextStyle(
              //                                                           fontSize: 20,
              //                                                         ),
              //                                                         decoration:
              //                                                             InputDecoration(
              //                                                           errorText: ChatService.validateUcl(_uclValue) ? null : 'Enter the Value',
              //                                                           contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
              //                                                           border: const UnderlineInputBorder(),
              //                                                           filled: true,
              //                                                           hintText: 'UCL value',
              //                                                           hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
              //                                                           enabledBorder: OutlineInputBorder(
              //                                                             borderSide: BorderSide(color: Colors.grey, width: 2),
              //                                                           ),
              //                                                           focusedBorder: OutlineInputBorder(
              //                                                             borderSide: BorderSide(color: Colors.transparent),
              //                                                           ),
              //                                                         ),
              //                                                         onSaved:
              //                                                             (value) {
              //                                                           uclCode = value!;
              //                                                           final temp = Uint8List.fromList(utf8.encode(uclCode));
              //                                                           setStateModal(() {
              //                                                             uclCode = uclCode;
              //                                                             uclinput = temp;
              //                                                           });
              //                                                         },
              //                                                       ),
              //                                                     ),
              //                                                   ),
              //                                                   SizedBox(
              //                                                     height:
              //                                                         10,
              //                                                   ),
              //                                                   Form(
              //                                                     key:
              //                                                         _lclKey,
              //                                                     child:
              //                                                         Container(
              //                                                       width:
              //                                                           MediaQuery.of(context).size.width * 0.5,
              //                                                       child:
              //                                                           TextFormField(
              //                                                         key:
              //                                                             ValueKey('lcl'),
              //                                                         validator:
              //                                                             (value) {
              //                                                           print(double.parse(value!));
              //                                                           if (double.parse(value) <= 2000.0 && double.parse(value) >= 0.0) {
              //                                                             print(double.parse(value));
              //                                                             return '';
              //                                                           }
              //                                                           return 'Enter LCL Value between 0 to 2000';
              //                                                         },
              //                                                         keyboardType:
              //                                                             TextInputType.number,
              //                                                         controller:
              //                                                             lclController,
              //                                                         onChanged:
              //                                                             (String? value) {
              //                                                           setState(() {
              //                                                             isValidUCLLCL = false;
              //                                                           });

              //                                                           _lclValue = value!;
              //                                                         },
              //                                                         style:
              //                                                             TextStyle(
              //                                                           fontSize: 20,
              //                                                         ),
              //                                                         decoration:
              //                                                             InputDecoration(
              //                                                           errorText: ChatService.validatelcl(_lclValue) ? null : 'Enter the Value',
              //                                                           contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
              //                                                           border: const UnderlineInputBorder(),
              //                                                           filled: true,
              //                                                           hintText: 'LCL value',
              //                                                           hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
              //                                                           enabledBorder: OutlineInputBorder(
              //                                                             borderSide: BorderSide(color: Colors.grey, width: 2),
              //                                                           ),
              //                                                           focusedBorder: OutlineInputBorder(
              //                                                             borderSide: BorderSide(color: Colors.transparent),
              //                                                           ),
              //                                                         ),
              //                                                         onSaved:
              //                                                             (value) {
              //                                                           lclCode = value!;
              //                                                           final temp = Uint8List.fromList(utf8.encode(lclCode));
              //                                                           setStateModal(() {
              //                                                             lclCode = lclCode;
              //                                                             lclinput = temp;
              //                                                           });
              //                                                         },
              //                                                       ),
              //                                                     ),
              //                                                   ),
              //                                                   SizedBox(
              //                                                     height:
              //                                                         10,
              //                                                   ),
              //                                                   ElevatedButton(
              //                                                       onPressed:
              //                                                           () {
              //                                                         setStateModal(() {
              //                                                           setUcltestFlag = true;
              //                                                         });
              //                                                         _submitForm3();
              //                                                         Future.delayed(const Duration(seconds: 4),
              //                                                             () {
              //                                                           setStateModal(() {
              //                                                             setUcltestFlag = false;
              //                                                           });
              //                                                           if (lclCode.isEmpty && uclCode.isEmpty) {
              //                                                             Navigator.of(context).pop();
              //                                                           }
              //                                                         });
              //                                                       },
              //                                                       child:
              //                                                           Text('SET UCL & LCL')),
              //                                                   setUcltestFlag &&
              //                                                           isValidUCLLCL
              //                                                       ? Center(
              //                                                           child: Container(
              //                                                             margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              //                                                             height: 50,
              //                                                             width: 210,
              //                                                             decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.green),
              //                                                             child: Center(
              //                                                               child: Row(children: [
              //                                                                 SizedBox(
              //                                                                   width: 10,
              //                                                                 ),
              //                                                                 Text(
              //                                                                   'UCL LCL Set Successfully',
              //                                                                   style: TextStyle(
              //                                                                     fontSize: 12,
              //                                                                   ),
              //                                                                 ),
              //                                                                 Icon(Icons.check)
              //                                                               ]),
              //                                                             ),
              //                                                           ),
              //                                                         )
              //                                                       : Container(),
              //                                                 ])));
              //                                       }));
              //                             },
              //                             child: Text("Set LCL UCL")),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //               actions: <Widget>[
              //                 ElevatedButton(
              //                   onPressed: () {
              //                     setState(() {
              //                       ucllclFlag = false;
              //                     });
              //                     Navigator.of(context).pop();
              //                   },
              //                   child: Text("Cancel"),
              //                 ),
              //               ],
              //             );
              //           }));
              // },
              //       child: Text('Setup')),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.8,
              //   height: 60.0,
              //   child: ElevatedButton(
              // onPressed: () async {
              //   await showDialog(
              //       context: context,
              //       builder: (BuildContext context) => StatefulBuilder(
              //               builder: (context, setStateModal) {
              //             return AlertDialog(
              //               title: Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   Text(
              //                     'Loop Test',
              //                     style: TextStyle(
              //                         fontWeight: FontWeight.w700),
              //                   ),
              //                   SizedBox(
              //                     height: 5,
              //                   ),
              //                   Text('Enter the Current value in mA.'),
              //                 ],
              //               ),
              //               content: Container(
              //                 width: 300,
              //                 height: 200,
              //                 child: Column(
              //                   children: [
              //                     Form(
              //                       key: _loopKey,
              //                       child: Container(
              //                         width: MediaQuery.of(context)
              //                                 .size
              //                                 .width *
              //                             0.6,
              //                         child: TextFormField(
              //                           key: ValueKey('loopKey'),
              //                           validator: (value) {
              //                             if (value!.isEmpty) {
              //                               return 'Please enter Current value';
              //                             }
              //                             return null;
              //                           },
              //                           keyboardType:
              //                               TextInputType.number,
              //                           style: TextStyle(
              //                             fontSize: 20,
              //                           ),
              //                           decoration: InputDecoration(
              //                             contentPadding:
              //                                 EdgeInsets.fromLTRB(
              //                                     30, 30, 30, 8),
              //                             border:
              //                                 const UnderlineInputBorder(),
              //                             filled: true,
              //                             hintText:
              //                                 'Loop Test Current value',
              //                             hintStyle: TextStyle(
              //                                 color: Colors.grey,
              //                                 fontSize: 20),
              //                             fillColor: Colors.pink[50],
              //                             enabledBorder:
              //                                 OutlineInputBorder(
              //                               borderRadius:
              //                                   BorderRadius.all(
              //                                       Radius.circular(
              //                                           30.0)),
              //                               borderSide: BorderSide(
              //                                   color: Colors.grey,
              //                                   width: 2),
              //                             ),
              //                             focusedBorder:
              //                                 OutlineInputBorder(
              //                               borderRadius:
              //                                   BorderRadius.all(
              //                                       Radius.circular(
              //                                           30.0)),
              //                               borderSide: BorderSide(
              //                                   color:
              //                                       Colors.transparent),
              //                             ),
              //                           ),
              //                           onSaved: (value) {
              //                             loopCode = double.parse(value!);
              //                             List<int> myList =
              //                                 Float32List.fromList(
              //                                         [loopCode])
              //                                     .buffer
              //                                     .asUint8List();
              //                             List<int> bytes = new List.from(
              //                                 myList.reversed);

              //                             setState(() {
              //                               loopFinalCmd = loopCMDFirst +
              //                                   bytes +
              //                                   loopCMDSecond;
              //                             });
              //                           },
              //                         ),
              //                       ),
              //                     ),
              //                     ElevatedButton(
              //                         onPressed: () {
              //                           setStateModal(() {
              //                             looptestFlag = true;
              //                           });
              //                           _submitForm2();
              //                           Future.delayed(
              //                               const Duration(seconds: 4),
              //                               () {
              //                             setStateModal(() {
              //                               looptestFlag = false;
              //                             });
              //                             Navigator.of(context).pop();
              //                           });
              //                         },
              //                         child: Text('Loop Test')),
              //                     looptestFlag && isValidLoop
              //                         ? Center(
              //                             child: Container(
              //                               margin:
              //                                   const EdgeInsets.fromLTRB(
              //                                       10, 10, 0, 10),
              //                               height: 50,
              //                               // alignment: AlignmentGeometry.lerp(0, , t),
              //                               width: 210,
              //                               decoration: BoxDecoration(
              //                                   borderRadius:
              //                                       BorderRadius.all(
              //                                           Radius.circular(
              //                                               20)),
              //                                   color: Colors.green),
              //                               child: Center(
              //                                 child: Row(children: [
              //                                   SizedBox(
              //                                     width: 10,
              //                                   ),
              //                                   Text(
              //                                     'Loop Test Success',
              //                                     style: TextStyle(
              //                                       fontSize: 18,
              //                                     ),
              //                                   ),
              //                                   Icon(Icons.check)
              //                                 ]),
              //                               ),
              //                             ),
              //                           )
              //                         : Container(),
              //                   ],
              //                 ),
              //                 //loopSet(),
              //               ),
              //             );
              //           }));
              // },
              //       child: Text('Loop Test')),
              // ),
              SizedBox(height: 30),
              currentCMDWidget(),
              // ElevatedButton(
              //     onPressed: () async {
              //       setState(() {
              //         fetchlcluclCMD = true;
              //       });
              //       //_sendMessagee(refreshCmd);
              //       fetchTag();
              //       await Future.delayed(const Duration(seconds: 5), () {
              //         setState(() {
              //           fetchlcluclCMD = false;
              //         });
              //       });
              //     },
              //     child: Text('Refresh'))
            ],
          ),
        ),
      ),
    );
  }

  Widget currentCMDWidget() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.blue,
      ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
          child: Text(
            'Refresh',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            setState(() {
              fetchlcluclCMD = true;
            });
            //_sendMessagee(refreshCmd);
            fetchTag();
            await Future.delayed(const Duration(seconds: 5), () {
              setState(() {
                fetchlcluclCMD = false;
              });
            });
            fetchlcl();
          }),
    );
  }

  Widget currentValueShow() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  '${current.toStringAsFixed(3)}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Range:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  '${range.toStringAsFixed(3)}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Process:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  '${process1.toStringAsFixed(3)}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PRange:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  '${process2.toStringAsFixed(3)}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ],
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
    var reverseValue = data.sublist(6, 15);
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
    print(upperValueUCL);
    print(lowerValueUCL);
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
      process2 = processVariable;
      process1 = currentValue;
    });
  }

//form submittion
  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      temptagCode = codeConversation(check1);
      tagFinalCmd = tagCMDFirst + temptagCode + tagCMDSecond;
      print(tagFinalCmd);
      _sendMessagee(tagFinalCmd);
      tagFinalCmd = [];
      temptagCode = [];
    } else {}
  }

  void _submitForm2() async {
    isValidLoop = _loopKey.currentState!.validate();
    if (isValidLoop) {
      _loopKey.currentState!.save();
      _sendMessagee(loopFinalCmd);
    } else {}
  }

  void _submitForm3() async {
    isValidUCLLCL = ChatService.validatelcl(_lclValue) &&
        ChatService.validateUcl(_uclValue);
    _uclKey.currentState!.validate();
    _lclKey.currentState!.validate();
    if (isValidUCLLCL) {
      _uclKey.currentState!.save();
      setState(() {
        ucllclFlag = true;
      });
      while (uclinput.length < 4) {
        uclinput.add(0);
        print('0000000000000000000000000000000000000000');
      }
      while (lclinput.length < 4) {
        lclinput.add(0);
        print('0000000000000000000000000000000000000000');
      }
      cmdforlclucl = lcluclCmd1 + unitinput + uclinput + lclinput + lcluclCmd2;
      setState(() {
        cmdforlclucl = cmdforlclucl;
      });
      _sendMessagee(cmdforlclucl);
      await Future.delayed(const Duration(seconds: 8), () {
        setState(() {
          ucllclFlag = false;
        });
      });
      //
    } else {}
  }

  Widget deviceDetails() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: screenLoaded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Manufacturer Name:',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      manufacture.length >= 28
                          ? Flexible(
                              child: isSubArray(
                                              isSubArray(
                                                  manufacture, macaddress, 10),
                                              [254],
                                              1)
                                          .first ==
                                      55
                                  ? Text(
                                      'YOKOGAWA',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                    )
                                  : Text(
                                      'Others',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                    ))
                          : Text('')
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(
                        'Tag Name:',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      )),
                      Flexible(
                          child: tag.length >= 30
                              ? Text(
                                  '${reverseConversation(isSubArray(tag, macaddress, 10).sublist(4, 10))}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                )
                              : Text(''))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lower Range:',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '${lCLVALUE.toStringAsFixed(3)}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upper Range:',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '${uCLVALUE.toStringAsFixed(3)}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Units Name:',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        unitNamedValue,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            : Container(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text('Loading Dashboard')
                  ],
                ),
              ));
  }
//Trimming Widgets______________________________________________________________________________________
//______________________________________________________________________________________________________
//______________________________________________________________________________________________________
//Zero Trimming, Upper Trimming , Lower Trimming , OutputTrimming Widgets are below.

//Zero Triming Widget
  Widget zerotrim() {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (ctx) => Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                child: AlertDialog(
                  title: Text("Zero Trimming"),
                  content: Text(
                      "Please Tap on below button to complete Zero Trimming"),
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
              ),
            );
          },
          child: Text("Zero Trimming"),
        ),
      ),
    );
  }

//Upper Triming Widget
  Widget uppertrim() {
    return Center(
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
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                        border: const UnderlineInputBorder(),
                        filled: true,
                        hintText: 'Enter value',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                        fillColor: Colors.white,
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius:
                        //       BorderRadius.all(Radius.circular(20.0)),
                        //   borderSide:
                        //       BorderSide(color: Colors.grey, width: 2),
                        // ),
                        // focusedBorder: OutlineInputBorder(
                        //   borderRadius:
                        //       BorderRadius.all(Radius.circular(30.0)),
                        //   borderSide: BorderSide(color: Colors.transparent),
                        // ),
                      ),
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
    );
  }

//Lower Triming Widget
  Widget lowertrim() {
    return Center(
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
                        fillColor: Colors.white,
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius:
                        //       BorderRadius.all(Radius.circular(20.0)),
                        //   borderSide:
                        //       BorderSide(color: Colors.grey, width: 2),
                        // ),
                        // focusedBorder: OutlineInputBorder(
                        //   borderRadius:
                        //       BorderRadius.all(Radius.circular(30.0)),
                        //   borderSide: BorderSide(color: Colors.transparent),
                        // ),
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
    );
  }

//Output Triming Widget
  Widget outputtrim() {
    return Center(
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
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                    border: const UnderlineInputBorder(),
                    filled: true,
                    hintText: 'Enter value',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                    fillColor: Colors.white,
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius:
                    //       BorderRadius.all(Radius.circular(20.0)),
                    //   borderSide:
                    //       BorderSide(color: Colors.grey, width: 2),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius:
                    //       BorderRadius.all(Radius.circular(30.0)),
                    //   borderSide: BorderSide(color: Colors.transparent),
                    // ),
                  ),
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
                content:
                    Text("Feild device output 4ma equal to reference meter?"),
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
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                    border: const UnderlineInputBorder(),
                    filled: true,
                    hintText: 'Enter value',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                    fillColor: Colors.white,
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius:
                    //       BorderRadius.all(Radius.circular(20.0)),
                    //   borderSide:
                    //       BorderSide(color: Colors.grey, width: 2),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius:
                    //       BorderRadius.all(Radius.circular(30.0)),
                    //   borderSide: BorderSide(color: Colors.transparent),
                    // ),
                  ),
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
                content:
                    Text("Feild device output 20ma equal to reference meter?"),
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
    );
  }
}
