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
          getStart(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Type your Name',
            ),
            validator: (_name) {
              if (_name.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: nameController,
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
                      builder: (context) => DemoPage(),
                    ),
                  );
                }
              },
              child: Text('Start'),
            ),
          ),
        ],
      ),
    );
  }
}