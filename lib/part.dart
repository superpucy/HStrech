import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stretch/part_detail.dart';

class PartPage extends StatefulWidget {
  @override
  _PartPageState createState() => _PartPageState();
}

class _PartPageState extends State<PartPage> {

  @override
  void initState() {

  }
  Widget buildDetails(String part) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('activity').where("parts",arrayContains:part).getDocuments(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return Text("共${snapshot.data.documents.length}組動作",style: TextStyle(fontSize: 12),);
        }else{
          return Container(child: Text('Loading...'),);
        }

      },
    );
  }

  Widget buildCard() {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('part').getDocuments(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          var name = snapshot.data.documents[0].data["name"];

          return ListView.separated(
              itemBuilder: (context, index){
                return GestureDetector(

                  child: ListTile(
//                    leading: Icon(Icons.favorite),
                    title: Text(name[index]),
                    subtitle:buildDetails(name[index]) ,
                    trailing:Icon(Icons.keyboard_arrow_right),
                  ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PartDetailPage(name[index])));
                  },
                );
              },
              itemCount: name.length,
              separatorBuilder: (context,index){
                return Divider(color: Colors.blueGrey,);
              },
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
  }
}