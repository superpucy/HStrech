import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlayPage extends StatefulWidget {
  PlayPage(this.id, {Key key}) : super(key: key);
  final String id;

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  QuerySnapshot packages;
  Map<String, DocumentSnapshot> activitys;

  bool loaded = false;

  List<Widget> imageList;
  PageController _pageController;
  Timer _timer;
  int time = 0;
  static const period = const Duration(seconds: 1);
//  AnimationController _controller;
  int count = 0;
  bool isActive = false;

  @override
  void initState() {
//    _pageController = new PageController(initialPage: 0);
    loadPackage();

    super.initState();
//    _controller = AnimationController(
//      duration: const Duration(seconds: 1),
//    );
  }

  loadPackage() async {
    packages = await Firestore.instance
        .collection("package")
        .document(widget.id)
        .collection("activities")
        .getDocuments();
    await loadActivity();
    time = int.parse(packages.documents[count].data["seconds"].toString());
    loaded = true;
    setState(() {});
  }

  loadActivity() async {
    await Future.forEach(packages.documents, (x) async {
      if (activitys == null) {
        activitys = Map();
      }
      var activityId = x.data["activity"];
      var activity = await Firestore.instance
          .collection("activity")
          .document(activityId)
          .get();
      if (!activitys.containsKey(activityId)) {
        activitys[activityId] = activity;
      }
    });
  }

  Widget _buildBody() {
    if (!loaded) {
      return Container(
        color: Colors.white,
        child: Text('Loading...'),
      );
    }
    return Column(
      children: <Widget>[
//        Container(
//            color: Colors.white,
//            child: CarouselSlider(
//              height: 400.0,
//              autoPlay: false,
//              enlargeCenterPage: true,
//              enableInfiniteScroll: false,
//              aspectRatio: 2.0,
//              items: packages.documents.map((i) {
//                return Builder(
//                  builder: (BuildContext context) {
//                    var activity = activitys[i.data["activity"]];
//                    return Container(
//                        width: MediaQuery.of(context).size.width,
//                        margin: EdgeInsets.symmetric(horizontal: 5.0),
//                        child: Image.network(
//                          '${activity.data["pic"].toString()}',
//                          width: double.infinity,
//                          fit: BoxFit.fitWidth,
//                        ));
//                  },
//                );
//              }).toList(),
//            )),
        Center(
            child: Image.network(
              '${activitys[packages.documents[count].data["activity"]].data["pic"].toString()}',
              width: double.infinity,
              height: 300,
              fit: BoxFit.scaleDown,
            ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: () {
                    setState(() {
                      count = count - 1;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(isActive?Icons.pause:Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      isActive = !isActive;
                    });
                    Timer.periodic(period, (timer) {
                      if (isActive) {
                        if (time < 1) {
                          if (count < packages.documents.length-1) {
                            setState(() {

                              count += 1;
                              time = int.parse(
                                  packages.documents[count].data["seconds"].toString());  
                            });
                          }else {
                            timer.cancel();
                            timer = null;
                          }
                        } else {
                          setState(() {
                            time--;
                          });
                        }
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: () {
                    setState(() {
                      count = count + 1;
                    });
                  },
                )
              ],
            )),
        Text(time.toString())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("伸展吧"),
            centerTitle: true,
            textTheme: Theme.of(context).appBarTheme.textTheme),
        body: _buildBody());
  }
}
