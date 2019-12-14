import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayPage extends StatefulWidget {
  PlayPage(this.id,{Key key}):super(key:key);
  final String id;
  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {

  QuerySnapshot packages;
  Map<String,DocumentSnapshot> activitys ;
  bool loaded = false;

  List<Widget> imageList;
  PageController _pageController;
  Timer _timer;
  @override
  void initState() {
//    _pageController = new PageController(initialPage: 0);
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
  @override
  Widget build(BuildContext context) {
    if(!loaded){
      return Container(child: Text('Loading...'),);
    }
    return CarouselSlider(
      height: 400.0,
      autoPlay: false,
      enlargeCenterPage: true,
      enableInfiniteScroll:false,
      aspectRatio: 2.0,
      items: packages.documents.map((i) {
        return Builder(
          builder: (BuildContext context) {
            var activity = activitys[i.data["activity"]];
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset('assets/activities/${activity.data["pic"].toString()}', width: 80,fit: BoxFit.fitWidth,)
            );
          },
        );
      }).toList(),
    );
  }
}