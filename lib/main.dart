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
  var _stringValue = "";
  var _nikkei = "";
  var _djv = "";
  var vested = 300; //既得株数


  String nikkei;
  String stringValue;
  bool boolValue;
  int intValue;
  double doubleValue;

  _saveBool(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  _saveString(String key,String value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }


  _restoreValues() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _stringValue = prefs.getString('stringValue') ?? "";
      _djv = prefs.getString('djv') ?? ""; //Dow averege
      nikkei = prefs.getString('998074') ?? ""; //Nikkei averege

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

//Read String
getStringValues() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  stringValue = prefs.getString('stringValue');
}

//Read data
getValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  stringValue = prefs.getString('stringValue');
  //Return bool
  boolValue = prefs.getBool('boolValue');
  //Return int
  intValue = prefs.getInt('intValue');
  //Return double
  doubleValue = prefs.getDouble('doubleValue');
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
    _saveString('_998074','0');
    _saveString('_djv','0');

    _restoreValues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pref Test'),
      ),
      body: Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: <Widget>[
          ListView(
            children: List.generate(2, (index) {
            return Card(
            child: Row(
              children: <Widget>[
                //Image.asset("assets/screen$index.jpg"),
                Container(
                    margin: EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text("screen$index.jpg"),
                      leading: Icon(Icons.person),
                      subtitle: Text("サブタイトル"),
                    ),),
              ],
            ),
          );
        },),
      ),
      
    Chip(
      avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('AH')),
      label: Text('Hamilton'),
    ),
    Chip(
      avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('ML')),
      label: Text('Lafayette'),
    ),
    Chip(
      avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('HM')),
      label: Text('Mulligan'),
    ),
    Chip(
      avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('JL')),
      label: Text('Laurens'),
    ),
  ],
)
    );
  }
}



///Common method to design a chip with different properties
///like label and background color
Widget chipDesign(String label, Color color) => Container(
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
              color: Colors.white, fontFamily: 'Raleway'),
        ),
        backgroundColor: color,
        elevation: 4,
        shadowColor: Colors.grey[50],
        padding: EdgeInsets.all(4),
      ),
      margin: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
    );



