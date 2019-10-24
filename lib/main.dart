import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
    debugPaintSizeEnabled = false;
    runApp(
      MaterialApp(
        home: MyApp(),
      ),
    );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<MyApp> {
  var _switch1 = false;
  var _switch2 = false;
  var _switch3 = false;

  _saveBool(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  _restoreValues() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _switch1 = prefs.getBool('bool1') ?? false;
      _switch2 = prefs.getBool('bool2') ?? false;
      _switch3 = prefs.getBool('bool3') ?? false;
    });
  }

  //Saving String value
  addStringToSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('stringValue', "abc");
}

//Saving double value
addIntToSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('intValue', 123);
}

//Saving boolean value
addBoolToSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('boolValue', true);
}

//Read data
getValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('stringValue');
  //Return bool
  bool boolValue = prefs.getBool('boolValue');
  //Return int
  int intValue = prefs.getInt('intValue');
  //Return double
  double doubleValue = prefs.getDouble('doubleValue');
}

// Remove data
removeValues() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Remove String
  prefs.remove("stringValue");
  //Remove bool
  prefs.remove("boolValue");
  //Remove int
  prefs.remove("intValue");
  //Remove double
  prefs.remove("doubleValue");
}

//Check value if present or not?
checkValues() async{
SharedPreferences prefs = await SharedPreferences.getInstance();
bool CheckValue = prefs.containsKey('value');
}





  @override
  void initState() {
    _restoreValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pref Test'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: <Widget>[
              SwitchListTile(
                value: _switch1,
                title: Text('Setting 1'),
                onChanged: (bool value) {
                  setState(() {
                    _switch1 = value;
                    _saveBool('bool1', value);
                  });
                },
              ),
              SwitchListTile(
                value: _switch2,
                title: Text('Setting 2'),
                onChanged: (bool value) {
                  setState(() {
                    _switch2 = value;
                    _saveBool('bool2', value);
                  });
                },
              ),
              SwitchListTile(
                value: _switch3,
                title: Text('Setting 3'),
                onChanged: (bool value) {
                  setState(() {
                    _switch3 = value;
                    _saveBool('bool3', value);
                  });
                },
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}