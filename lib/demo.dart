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
    print("==============");


    hubConnection.on("ReceiveMessage", _handle);
    try {
      final result =
      await hubConnection.invoke("SendMessage", args: ["dora", y.toString()]);
      print(result);
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
  }

  @override
  void initState() {
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



    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[

        Padding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Accelerometer: $accelerometer'),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
        ),
        Padding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('UserAccelerometer: $userAccelerometer'),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
        ),
        Padding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Gyroscope: $gyroscope'),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
        ),
      ],
    );
  }



}