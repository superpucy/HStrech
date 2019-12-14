import 'dart:io' show Platform;
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:stretch/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:webview_flutter/webview_flutter.dart';

class MyPackagePage extends StatefulWidget {
  @override
  _MyPackagePageState createState() => _MyPackagePageState();
}

class _MyPackagePageState extends State<MyPackagePage> {

  @override
  void initState() {

  }

  Widget buildCard() {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('package').getDocuments(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return ListView.builder(
              itemBuilder: (context, index){
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/007-baseball-player-playing-stick-man.png',width: 100,),
                        Column(
                          children: <Widget>[

                            Text(snapshot.data.documents[index].data["name"]),
                          ],
                        )

                      ],
                    ),
                  )
                );
              },
//              separatorBuilder: (context,index){
//                return Divider(color: Colors.blueGrey,);
//              },
              itemCount: snapshot.data.documents.length,
              scrollDirection: Axis.vertical);
        }else{
          return Container(child: Text('Loading...'),);
        }

      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return buildCard();
//    return WebView(initialUrl: "https://players.brightcove.net/5507778861001/default_default/index.html?videoId=5531113670001",);
  }
}