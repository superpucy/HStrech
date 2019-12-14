import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartDetailPage extends StatefulWidget {

  PartDetailPage(this.part,{Key key}):super(key:key);
  final String part;
  @override
  _PartDetailPageState createState() => _PartDetailPageState();

}

class _PartDetailPageState extends State<PartDetailPage> {
  @override
  void initState() {

  }

  Widget buildCard() {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('activity').where("parts",arrayContains:widget.part).getDocuments(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //每行三列
              childAspectRatio: 1.0 //显示区域宽高相等
          ),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
            return GestureDetector(
              child: Card(
                child: Image.asset('assets/activities/${snapshot.data.documents[index].data["pic"]}',fit: BoxFit.cover,),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
              onTap: (){

              },
            );
          },);
//          return ListView.separated(
//              itemBuilder: (context, index){
//                return GestureDetector(
//                  child: Card(
//                    child: Image.asset('assets/activities/${snapshot.data.documents[index].data["pic"]}',fit: BoxFit.cover,),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(10.0),
//                    ),
//                    elevation: 5,
//                    margin: EdgeInsets.all(10),
//                  ),
//                  onTap: (){
//
//                  },
//                );
//              },
//              itemCount: snapshot.data.documents.length,
//              separatorBuilder: (context,index){
//                return Divider(color: Colors.blueGrey,);
//              },
//              scrollDirection: Axis.vertical);
        }else{
          return Container(child: Text('Loading...'),);
        }

      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.part),
        centerTitle: true,
      ),
      backgroundColor: const Color(0XFFEEEEEE),
      body:  buildCard()
    );

  }
}