//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stretch/demo.dart';
import 'package:stretch/history.dart';
import 'package:stretch/package.dart';
import 'package:stretch/part.dart';
import 'package:stretch/start.dart';
import 'dart:io' show Platform;

import 'api.service.dart';
import 'my_package.dart';

void main() async{

  runApp(MyHomePage());
}

ApiService apiService;


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
//  final FirebaseApp app;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> pages = List<Widget>();
  int currentIndex = 0;

//  FirebaseDatabase database ;
  @override
  void initState() {
    super.initState();
//    database = FirebaseDatabase(app: widget.app);
    pages.add(StartPage());
    pages.add(PackagePage());
    pages.add(MyPackagePage());
    pages.add(PartPage());
    pages.add(HistoryPage());
  }

//  _init() {
//    apiService = ApiService(database: database);
//  }

  @override
  Widget build(BuildContext context) {
//    _init();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          title: TextStyle(
              fontFamily: 'PingFangTC-Medium',
              fontSize: 8
          ),
        ),
        backgroundColor: const Color(0XFFA3A3A3A3),
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          iconTheme: IconThemeData(
            color: const Color(0XFFFFFFFF),
          ),
          color: const Color(0XFF6EC16E),

          textTheme: TextTheme(
            title: TextStyle(
                fontFamily: 'PingFangTC-Medium',
                fontSize: 14
            ),
          ),
        )
      ),
      home: Scaffold(
//        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("伸展吧"),
          centerTitle: true,
          textTheme: Theme.of(context).appBarTheme.textTheme,
        ),
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
//          unselectedItemColor: const Color(0xFFEEEEEE),
          selectedItemColor: const Color(0xFF204656),
          selectedFontSize: 8,
          unselectedFontSize: 8,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index){
            setState(() {
              this.currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list),title: Text("Demo")),
            BottomNavigationBarItem(icon: Icon(Icons.list),title: Text("伸展組合")),
            BottomNavigationBarItem(icon: Icon(Icons.list),title: Text("我的組合")),
            BottomNavigationBarItem(icon: Icon(Icons.accessibility_new),title: Text("部位")),
            BottomNavigationBarItem(icon: Icon(Icons.history),title: Text("歷程")),
          ],
        ),
      )
    );

  }
}
