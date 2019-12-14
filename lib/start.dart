import 'demo.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: getStart(),
          ),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();


  getStart () {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
         TextFormField(
              decoration: const InputDecoration(
                hintText: '你的名字是？',
                prefixIcon: Icon(Icons.face),
              ),
              validator: (_name) {
                if (_name.isEmpty) {
                  return '輸入名字！！！';
                }
                return null;
              },
              textAlign: TextAlign.center,
              controller: nameController,
            ),
          Image(
              image: AssetImage('assets/landing.png'),
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    print(nameController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DemoPage(username: nameController.text),
                      ),
                    );
                  }
                },
                child: Text('開始'),
              ),
            ),


        ],
      ),
    );
  }
}