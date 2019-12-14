import 'package:flutter/material.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stretch/database.dart';



class HistoryPage extends StatefulWidget {





  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  String value = "";
  double a = 0;
  int b = 0;
  String level ="";

  Future<int> getLog() async {
    final db = await DBProvider.db.database;
    var res = await db.rawQuery('SELECT * FROM log');
    if(res.isEmpty) {
      return 0;
    }else{
      return res.length;
    }
  }


  @override
  void initState() {

    super.initState();

    getLog().then((x){
      setState(() {
        b = x;
      });
    });
  }


  Widget buildText(){

    style: TextStyle(
        fontSize: 200,
        fontWeight: FontWeight.bold,
        fontFamily: 'Oswald');

    if(a <= 0.25){

      return Text('Level_one');

    }

    else if(a <= 0.75){

      return Text('Level_two');


    }

    else{
      return Text('Level_three');
    }



  }


  Widget buildImage(){
    if(a <= 0.25){


      return Image.asset('assets/activities/award_three.png',

        height:100,
        width: 100,

      );




    }

    else if(a <= 0.75){

      return Image.asset('assets/activities/award_two.png',

        height:100,
        width: 100,);



    }

    else{
      return Image.asset('assets/activities/award_one.png',

        height:100,
        width: 100,


      );
    }
  }

  @override
  Widget build(BuildContext context) {


    return Container(



      child: Column(

        children: <Widget>[





          TextField(



            onChanged: (text) {

              value = text;

              setState(() {
                //a = int.parse(text)/y;

                a = b /int.parse(value );
              });
            },
          ),
//
//
//        ),

          Container(
            padding: EdgeInsets.fromLTRB(30, 30, 0, 30),

            child:LinearPercentIndicator(

              width: MediaQuery.of(context).size.width - 50,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 2000,
              percent: a,
              center: Text("${a * 100 }%"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.greenAccent,
            ),),

          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),

            child: Text('設定天數： ${value}天',

                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oswald'
                )



            ),



          ),

          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),

            child: Text('已完成天數：$b天',

                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oswald'
                )



            ),



          ),






          buildText(),

          buildImage(),













        ],



      ),

    );
  }
}