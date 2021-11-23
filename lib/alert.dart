
  // Widget uppertrim() {
  //   return Container(
  //     child: Center(
  //       child: ElevatedButton(
  //         onPressed: () async {
  //           await showDialog(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               title: Text("Action needed"),
  //               content: Text("Do you want to do upper trim"),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     higher = true;
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("OK"),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     higher = false;
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("Cancel"),
  //                 ),
  //               ],
  //             ),
  //           );

  //           if (higher) {
  //             await showDialog(
  //               context: context,
  //               builder: (ctx) => AlertDialog(
  //                 title: Text("Action needed"),
  //                 content: Text("Apply High Pressure"),
  //                 actions: <Widget>[
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(ctx).pop();
  //                     },
  //                     child: Text("OK"),
  //                   ),
  //                 ],
  //               ),
  //             );
  //             await showDialog(
  //               context: context,
  //               builder: (ctx) => AlertDialog(
  //                 title: Text("Please Wait till pressure becomes stable"),
  //                 actions: <Widget>[
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(ctx).pop();
  //                     },
  //                     child: Text("OK"),
  //                   ),
  //                 ],
  //               ),
  //             );
  //             await showDialog(
  //               context: context,
  //               builder: (ctx) => AlertDialog(
  //                 title: Text("Enter the pressure value applied"),
  //                 content: TextField(),
  //                 actions: <Widget>[
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(ctx).pop();
  //                     },
  //                     child: Text("OK"),
  //                   ),
  //                 ],
  //               ),
  //             );
  //             await showDialog(
  //               context: context,
  //               builder: (ctx) => AlertDialog(
  //                 title: Text("Action needed"),
  //                 content: Text("Upper Trim Completed Successfull"),
  //                 actions: <Widget>[
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(ctx).pop();
  //                     },
  //                     child: Text("OK"),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }
  //         },
  //         child: Text("Upper Trim"),
  //       ),
  //     ),
  //   );
  // }

  // Widget lowertrim() {
  //   return Container(
  //     child: Center(
  //       child: ElevatedButton(
  //         onPressed: () async {
  //           await showDialog(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               title: Text("Action needed"),
  //               content: Text("Do you want to do lower trim"),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     lower = true;
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("OK"),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     lower = false;
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("Cancel"),
  //                 ),
  //               ],
  //             ),
  //           );

  //           if (lower) {
  //             await showDialog(
  //               context: context,
  //               builder: (ctx) => AlertDialog(
  //                 title: Text("Action needed"),
  //                 content: Text("Apply Low Pressure"),
  //                 actions: <Widget>[
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(ctx).pop();
  //                     },
  //                     child: Text("OK"),
  //                   ),
  //                 ],
  //               ),
  //             );
  //             await showDialog(
  //               context: context,
  //               builder: (ctx) => AlertDialog(
  //                 title: Text("Please Wait till pressure becomes stable"),
  //                 actions: <Widget>[
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(ctx).pop();
  //                     },
  //                     child: Text("OK"),
  //                   ),
  //                 ],
  //               ),
  //             );
  //             await showDialog(
  //               context: context,
  //               builder: (ctx) => AlertDialog(
  //                 title: Text("Enter the pressure value applied"),
  //                 content: TextField(),
  //                 actions: <Widget>[
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(ctx).pop();
  //                     },
  //                     child: Text("OK"),
  //                   ),
  //                 ],
  //               ),
  //             );
  //             await showDialog(
  //               context: context,
  //               builder: (ctx) => AlertDialog(
  //                 title: Text("Action needed"),
  //                 content: Text("Lower Trim Completed Successfull"),
  //                 actions: <Widget>[
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(ctx).pop();
  //                     },
  //                     child: Text("OK"),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }
  //         },
  //         child: Text("Lower Trim"),
  //       ),
  //     ),
  //   );
  // }

  // Widget alert() {
  //   return Container(
  //     child: Center(
  //       child: ElevatedButton(
  //         onPressed: () async {
  //           await showDialog(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               title: Text("Action needed"),
  //               content: Text("Connect Reference meter and press ok"),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("OK"),
  //                 ),
  //               ],
  //             ),
  //           );
  //           await showDialog(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               title: Text("Action needed"),
  //               content: Text("press OK to trim output current for 4 mA"),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("OK"),
  //                 ),
  //               ],
  //             ),
  //           );
  //           await showDialog(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               title: Text("Enter the meter value"),
  //               content: TextField(),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("OK"),
  //                 ),
  //               ],
  //             ),
  //           );
  //           await showDialog(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               title: Text("Action needed"),
  //               content: Text("Feild device output 4ma equal to reference meter?"),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     outer = true;
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("YES"),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     outer = false;
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("NO"),
  //                 ),
  //               ],
  //             ),
  //           );
  //           await showDialog(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               title: Text("Action needed"),
  //               content: Text("press OK to trim output current for 20 mA"),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("OK"),
  //                 ),
  //               ],
  //             ),
  //           );
  //           await showDialog(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               title: Text("Enter the meter value"),
  //               content: TextField(),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     outer = true;
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("OK"),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                      outer = false;
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("Cancel"),
  //                 ),
  //               ],
  //             ),
  //           );
  //           await showDialog(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               title: Text("Action needed"),
  //               content: Text("Feild device output 20ma equal to reference meter?"),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   onPressed: () {
  //                                           outer = true;
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("OK"),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                                           outer = false;
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("Cancel"),
  //                 ),
  //               ],
  //             ),
  //           );

  //           await showDialog(
  //             context: context,
  //             builder: (ctx) => AlertDialog(
  //               title: Text("Action needed"),
  //               content: Text("Loop return to automatic control"),
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text("OK"),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //         child: Text("Output Trimming"),
  //       ),
  //     ),
  //   );
  // }