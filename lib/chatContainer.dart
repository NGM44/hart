import 'package:flutter/material.dart';

class ChatContainer{

    Widget connecting(String serverName,bool isConnected,bool isConnecting) {
    return  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text('Modem Status:'),  Container(
      margin: const EdgeInsets.fromLTRB(100, 10, 0, 10),
      height: 35,
     // alignment: AlignmentGeometry.lerp(0, , t),
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: isConnecting
            ? Colors.orange
            : isConnected
                ? Colors.green
                : Colors.red,
      ),
      child: isConnecting
          ? Align(
      alignment: Alignment.topRight,
      child: Center(
                child: Text(
                  isConnecting
            ? 'Connecting'
            : isConnected
                ? 'Connected'
                : 'Disconnected',
                  style: TextStyle(
                    fontSize: 14,
                     fontWeight: FontWeight.w800,
                  color: Colors.white
                  ),
                ),
              ),
          )
          : isConnected
              ? Align(
      alignment: Alignment.topRight,
      child:Center(
                    child: Text(
                      isConnecting
            ? 'Connecting'
            : isConnected
                ? 'Connected'
                : 'Disconnected',
                      style: TextStyle(
                        fontSize: 14,
                         fontWeight: FontWeight.w800,
                          color: Colors.white
                      ),
                    ),
                  ),
              )
              : Align(
      alignment: Alignment.topRight,
      child: Center(
                    child: Text(
                      isConnecting
            ? 'Connecting'
            : isConnected
                ? 'Connected'
                : 'Disconnected',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                          color: Colors.white
                      ),
                    ),
                  ),
              ),
    ),
    SizedBox(width: 15,),
    ]);
  }
}