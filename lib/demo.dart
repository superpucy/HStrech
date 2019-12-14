import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:stretch/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensors/sensors.dart';
import 'package:signalr_client/signalr_client.dart';
class DemoPage extends StatefulWidget {

  String username = "";
  DemoPage({
    this.username,
  });

  @override
  _DemoPageState createState() => _DemoPageState();
}



class _DemoPageState extends State<DemoPage> {

  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];

  static String serverUrl = "https://signalrservices.azurewebsites.net/messageHub";
  final hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();


  Future signalr(double x,double y,double z) async {

    try {
      final result =
      await hubConnection.invoke("SendAllMessage", args: [widget.username, y.toInt().toString()]);
    } finally {

    }
  }
  void _handle(List<Object> obj) {
    print(obj);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    hubConnection.off("ServerInvokeMethodNoParametersNoReturnValue",
        method: _handle);
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    hubConnection.on("ReceiveMessage", _handle);
    hubConnection.start().then((_){
      _streamSubscriptions
          .add(accelerometerEvents.listen((AccelerometerEvent event) {
        setState(() {
          _accelerometerValues = <double>[event.x, event.y, event.z];
          signalr(event.x,event.y,event.z);
        });
      }));
      _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
        setState(() {
          _gyroscopeValues = <double>[event.x, event.y, event.z];
        });
      }));
      _streamSubscriptions
          .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
        setState(() {
          _userAccelerometerValues = <double>[event.x, event.y, event.z];
        });
      }));
    });


  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();

    
    return Scaffold(
        appBar: AppBar(
            title: Text("快快樂樂"),
            centerTitle: true,
            textTheme: Theme.of(context).appBarTheme.textTheme),
        body: Column(
          children: <Widget>[
            Image.network("https://media.giphy.com/media/kcTpdLpgRC3z8QG8JW/giphy.gif"),
            RaisedButton(
              onPressed: () async{
                try {
                  final result =
                      await hubConnection.invoke("RemoveUser", args: [widget.username]);
                } finally {

                }
                Navigator.of(context).pop();
              },
              child: Text("結束"),
            )
          ],
        )
    );
  }



}