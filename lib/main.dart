import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html';
import 'dart:async';

void main() {
    debugPaintSizeEnabled = false;// Remove to suppress visual layout
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
  var vested = 300; //既得株数
  var code = ["Nikkei","Newyork"];
 
  String nikkei;
  String newyork;

  String stringValue;
  Future<String> stringValues;
  String stringCode;
  int counter = 99;

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
      newyork = prefs.getString('^DJV') ?? ""; //Dow averege
      nikkei = prefs.getString('Nikkei') ?? ""; //Nikkei averege
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

addIntTosf(String code,int intvalue) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(code, intvalue);
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

_getStringValues(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  stringCode = prefs.getString(code[index]);
  
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
//bool CheckValue = prefs.containsKey('value');
}





final Storage _localStorage = window.localStorage;

Future save(String key,String id) async {
    _localStorage[key] = id;
}

Future<String> getId(String key) async {
  stringValue = _localStorage[key];
}
Future invalidate() async {
    _localStorage.remove('selected_id');
}

 


  @override
  void initState() {
    save("Nikkei","998407");
    save("Newyork","^DJV");
    if (_localStorage.containsKey('selected_id')){
      stringValue = "true";
    }else{
      stringValue = "false";
    }


    
    //getId("Nikkei");
    //addStringToSF();
    //getStringValues();

    //_saveMarket();
   // _saveString("Nikkei","999999");
   // _restoreValues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pref Test'),
      ),
      body: Center(child: buildGrid()),
     );
    }

    Widget buildRow() =>
      // #docregion Row
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Image.asset('images/pic1.jpg')"),
          Text("Image.asset('images/pic2.jpg')"),
          Text("Image.asset('images/pic3.jpg')"),
        ],
      );
  // #enddocregion Row

  Widget buildColumn() =>
      // #docregion Column
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Image.asset('images/pic1.jpg'),
          //Image.asset('images/pic2.jpg'),
          //Image.asset('images/pic3.jpg'),
        ],
      );
  // #enddocregion Column

  Widget buildGrid() => GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,// Generate 100 widgets that display their index in the List.
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(5.0),
          childAspectRatio: (1 / 1), //幅/高さ←比を計算していれる。
          children: List.generate(2, (index) {
            //String tempindex = index.toString();
            getId(code[index].toString());
            //_getStringValues(index);
            return  Container(
              height: 5,
              child: Card(
                      color: Colors.green,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("${code[index]}",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text( stringValue ?? "null string"),
                            leading: Icon(
                              Icons.restaurant_menu,
                              color: Colors.blue[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                );
          }),
    );
        
  
      
      
  Widget buildCard() => SizedBox(
    height: 210,
    child: Card(
      child: Column(
        children: [
          ListTile(
            title: Text('1625 Main Street',
                style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('My City, CA 99984'),
            leading: Icon(
              Icons.restaurant_menu,
              color: Colors.blue[500],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('(408) 555-1212',
                style: TextStyle(fontWeight: FontWeight.w500)),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text('costa@example.com'),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
        ],
      ),
    ),
  );
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



