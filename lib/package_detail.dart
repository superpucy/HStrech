import 'dart:io' show Platform;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:stretch/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:stretch/main.dart';

class PackageDetailPage extends StatefulWidget {
  PackageDetailPage(this.title,this.id,{Key key}):super(key:key);
  final String id;
  final String title;
  @override
  _PackageDetailPageState createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {

  QuerySnapshot packages;
  Map<String,DocumentSnapshot> activitys ;
  bool loaded = false;

  @override
  void initState() {
    loadPackage();

    super.initState();
  }


  loadPackage() async{
    packages = await Firestore.instance.collection("package").document(widget.id).collection("activities").getDocuments();
    await loadActivity();
    loaded = true;
    setState(() {
    });
  }

  loadActivity() async{
    await Future.forEach(packages.documents, (x)async{
      if(activitys == null){
        activitys = Map();
      }
      var activityId = x.data["activity"];
      var activity = await Firestore.instance.collection("activity").document(activityId).get();
      if(!activitys.containsKey(activityId)){
        activitys[activityId] = activity;
      }
    });
  }


  Widget buildImage(String id) {
    return  FutureBuilder(
      future: Firestore.instance.collection("activity").document(id).get(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData) {
            print(id);
            print(snapshot.data["pic"].toString());
            return Image.asset('assets/activities/${snapshot.data["pic"].toString()}', width: 80,fit: BoxFit.fitWidth,);
          }else{
            return Image.asset('assets/activities/001.png', width: 80,fit: BoxFit.fitWidth);
          }
        }else{
          return Image.asset('assets/activities/001.png', width: 80,fit: BoxFit.fitWidth);
        }
      }
    );
  }

  Widget buildCard() {
    if(!loaded){
      return Container(child: Text('Loading...'),);
    }
    return ListView.separated(
        itemBuilder: (context, index){
          var activity = activitys[packages.documents[index].data["activity"]];
          return ListTile(
            leading: Image.asset('assets/activities/${activity.data["pic"].toString()}', width: 80,fit: BoxFit.fitWidth,),
            title: Text(activity.data["desc"].toString()),
            subtitle: Text("${packages.documents[index].data["seconds"]}秒，重複${packages.documents[index].data["times"]}次"),
            trailing:Icon(Icons.keyboard_arrow_right),
          );

        },
        separatorBuilder: (context,index){
          return Divider(color: Colors.blueGrey);
        },
        itemCount: packages.documents.length,
        scrollDirection: Axis.vertical);
//    return FutureBuilder<QuerySnapshot>(
//      future: Firestore.instance.collection("package").document(widget.id).collection("activities").getDocuments(),
//      builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//        if(snapshot.connectionState == ConnectionState.done){
//          if(!snapshot.hasData){
//            return Container(child: Text('error...'),);
//          }
//          return ListView.separated(
//              itemBuilder: (context, index){
//                return ListTile(
//                  leading: buildImage(snapshot.data.documents[index].data["activity"]),
//                  title: Text(snapshot.data.documents[index].data["activity"]),
//                  trailing:Icon(Icons.keyboard_arrow_right),
//                );
//
//              },
//              separatorBuilder: (context,index){
//                return Divider(color: Colors.blueGrey);
//              },
//              itemCount: snapshot.data.documents.length,
//              scrollDirection: Axis.vertical);
//        }else{
//          return Container(child: Text('Loading...'),);
//        }
//
//      },
//    );
  }

  Widget buildVideo() {
    if(!loaded){
      return Container(child: Text('Loading...'),);
    }
    return Swiper(
        itemBuilder: (context, index) {
          var activity = activitys[packages.documents[index].data["activity"]];
          return Image.asset('assets/activities/${activity.data["pic"].toString()}', width: 80,fit: BoxFit.fitWidth,);
        },
//        autoplayDelay: 5000,
//        autoplay: true,
        autoplayDisableOnInteraction: false,
//            loop: true,
        itemCount: packages.documents.length,
        index: 0,
        duration: 1000,
        pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              color: Colors.white,
              activeColor: const Color(0XFF00CC66),
            )),
        controller: SwiperController(),
        scrollDirection: Axis.horizontal);
//    return FutureBuilder<QuerySnapshot>(
//      future: Firestore.instance.collection("package").document(widget.id).collection("activities").getDocuments(),
//      builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//        if(snapshot.connectionState == ConnectionState.done){
//          if(!snapshot.hasData){
//            return Container(child: Text('error...'),);
//          }
//          return Container(
//            height: 300,
//            child: Swiper(
//                itemBuilder: (context, index) {
//                  return buildImage(snapshot.data.documents[index].data["activity"]);
//                },
//                autoplayDelay: 5000,
//                autoplay: true,
//                autoplayDisableOnInteraction: false,
////            loop: true,
//                itemCount: snapshot.data.documents.length,
//                index: 0,
//                duration: 1000,
//                pagination: SwiperPagination(
//                    builder: DotSwiperPaginationBuilder(
//                      color: Colors.white,
//                      activeColor: const Color(0XFF00CC66),
//                    )),
//                controller: SwiperController(),
//                scrollDirection: Axis.horizontal),
//          );
//          return ListView.separated(
//              itemBuilder: (context, index){
//                return ListTile(
//                  leading: buildImage(snapshot.data.documents[index].data["activity"]),
//                  title: Text(snapshot.data.documents[index].data["activity"]),
//                  trailing:Icon(Icons.keyboard_arrow_right),
//                );
//
//              },
//              separatorBuilder: (context,index){
//                return Divider(color: Colors.blueGrey);
//              },
//              itemCount: snapshot.data.documents.length,
//              scrollDirection: Axis.vertical);
//        }else{
//          return Container(child: Text('Loading...'),);
//        }
//
//      },
//    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        backgroundColor: const Color(0XFFEEEEEE),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: buildVideo()
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  child: buildCard()
              ),
            ),
          ],
        )
    );
  }
}