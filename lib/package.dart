import 'dart:io' show Platform;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:stretch/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stretch/main.dart';
import 'package:stretch/package_detail.dart';

class PackagePage extends StatefulWidget {
  @override
  _PackagePageState createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {




  @override
  void initState() {

  }

  Widget buildImage(String pic) {
    final ref = apiService.storage.ref().child("sports").child('${pic}');
    print(ref);
    return  FutureBuilder(
      future: ref.getDownloadURL(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData) {
            return Image.network(snapshot.toString(), width: 80,);
          }else{
            return Container(child: Text('error'),);
          }
        }else{
          return Container(child: Text('Loading...'),);
        }
      }
    );
  }

  Widget buildCard() {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('package').getDocuments(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return ListView.separated(
              itemBuilder: (context, index){
                var pic = snapshot.data.documents[index].data["pic"].toString();
                return ListTile(
                  leading: Image.network('${pic}'),
//                  isThreeLine: true,
                  title: Text(snapshot.data.documents[index].data["name"]),
                  subtitle: Text("時間：${snapshot.data.documents[index].data["seconds"]}".toString()),
                  trailing: Icon(Icons.play_circle_outline),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PackageDetailPage(snapshot.data.documents[index].data["name"],snapshot.data.documents[index].documentID)));
                  },
                );

              },
              separatorBuilder: (context,index){
                return Divider(color: Colors.blueGrey);
              },
              itemCount: snapshot.data.documents.length,
              scrollDirection: Axis.vertical);
//          return ListView.separated(
//              itemBuilder: (context, index){
//                return Container(
//                  padding: EdgeInsets.all(16),
//                  child: Row(
//                    children: <Widget>[
//                      Image.asset('assets/007-baseball-player-playing-stick-man.png',width: 80,),
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//
//                          Text(snapshot.data.documents[index].data["name"], textAlign:TextAlign.start,),
//                          Text(snapshot.data.documents[index].data["seconds"].toString()),
//                        ],
//                      )
//
//                    ],
//                  ),
//                );
//              },
//              separatorBuilder: (context,index){
//                return Divider(color: Colors.blueGrey,indent: 96,);
//              },
//              itemCount: snapshot.data.documents.length,
//              scrollDirection: Axis.vertical);
        }else{
          return Container(child: Text('Loading...'),);
        }

      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return buildCard();
  }
}