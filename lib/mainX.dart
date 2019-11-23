import 'package:flutter/material.dart';
import 'package:localstorage/key_finder_interface.dart';
//import 'package:localstorage/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    KeyFinder keyFinder = KeyFinder();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: KeyValueWidget(
          keyFinder: keyFinder,
        ),
      ),
    );
  }
}

class KeyValueWidget extends StatefulWidget {
  final KeyFinder keyFinder;

  KeyValueWidget({this.keyFinder});
  @override
  _KeyValueWidgetState createState() => _KeyValueWidgetState();
}

class _KeyValueWidgetState extends State<KeyValueWidget> {
  String key = "MyKey";
  TextEditingController _keyTextController = TextEditingController();
  TextEditingController _valueTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 200.0,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Text(
                '$key / ${widget.keyFinder.getKeyValue(key)}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Key",
                  border: OutlineInputBorder(),
                ),
                controller: _keyTextController,
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Value",
                  border: OutlineInputBorder(),
                ),
                controller: _valueTextController,
              ),
            ),
            RaisedButton(
              child: Text('Save new Key/Value Pair'),
              onPressed: () {
                widget.keyFinder.setKeyValue(
                  _keyTextController.text,
                  _valueTextController.text,
                );
                setState(() {
                  key = _keyTextController.text;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}