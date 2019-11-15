import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



GridView gridView1() => new GridView.builder(
  //itemCount: widgets.length,//<-- setState()
  //itemCount: 3,
  gridDelegate:new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
  itemBuilder: (BuildContext context, int index) {
    return new GestureDetector(
      child: new Card(
        color: Colors.grey[850],
        elevation: 5.0,
        child: new Container(
          //color: Colors.black38,
          //padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          //alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("({widgets[index].code}) "+"{widgets[index].name}",
                  style: TextStyle(fontSize: 9.0, color: Colors.white),),
              new Text("現在値 {separate(widgets[index].realValue.toString())}",
                  style: TextStyle(fontSize: 10.0, color: Colors.white),),
              new Text("利益　{separate(widgets[index].gain.toString())}",
                  style: TextStyle(fontSize: 10.0, fontFamily: 'Roboto',color: Colors.yellow),),
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  child: Text('AB'),
                ),
                label: Text('Aaron Burr'),
              )
    
            ],
              
          ),
                //alignment: Alignment.center,
                //child: new Text("${widgets[index].code}",style: TextStyle(fontSize: 10.0, color: Colors.white),),//new Text('Item $index'),
        ),
                //alignment: Alignment.center,
                //child: new Text('Item $index'),
      ),
    );
  });






void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
Future post;
 var _chipList = List<Chip>();
 var _keyNumber = 0;
 String price;

  @override
  void initState() {
    super.initState();
    post = fetch();
    _addChip("price");
        //print("out");
  }


void _addChip(String text) {
    var chipKey = Key('chip_key_$_keyNumber');
    _keyNumber++;

    _chipList.add(
      Chip(
        key: chipKey,
        label: Text(text),
        onDeleted: () => _deleteChip(chipKey),
      ),
    );
  }

  void _deleteChip(Key chipKey) {
    setState(() => _chipList.removeWhere((Widget w) => w.key == chipKey));
  }


Future fetch() async {
  final  response =
      await http.get("https://stocks.finance.yahoo.co.jp/stocks/detail/?code=6976.T");//^DJI
      final String json = response.body;


      //print(response);
      //RegExp regexp = RegExp(r"^/?code=");
      //String match = json;
      //regexp.allMatches(response.body).forEach((match) {
      //  String iconName = match.group(1);
      //  String codePoint = match.group(2);
        
      //});

      //RegExp match1 = RegExp(r"/[0-9]+/");
      //print("abc123".allMatches(match1,0));        // => 123


      //var invalidEmail = 'f@il@example.com';
      //Iterable<Match> matches = new RegExp(/@'@').allMatches(invalidEmail);
      //for (Match m in matches) {
      //  print(m.group(0));
      //}

      RegExp regExp = RegExp(r'[0-9]{1,},[0-9]{1,}');//new RegExp(r"/[0-9]+/");
      price = regExp.stringMatch(json).toString();
      print("StockPrice : "+price);
      
      var intprice;
      try {
            intprice = int.parse(price.replaceAll(",", "")); 
      } catch (exception) {
            intprice = 0.0;
      }
      
      print("string to int : "+intprice.toString());
        
      //print("allMatches : "+regExp.allMatches(json).toString());
      //print("firstMatch : "+regExp.firstMatch(json).toString());
      print("hasMatch : "+regExp.hasMatch(json).toString());
      //for (Match match in matches) {
      //  print(match.group(1));
      //}


      regExp = RegExp(r'[+-][0-9]{1,}.[+-]..[0-9]{1,}%.');//new RegExp(r"/[0-9]+/");
      //print("stringMatch : "+regExp.stringMatch(json).toString());
      String change = regExp.stringMatch(json).toString();
      print("Change : "+change);
        
     // print("allMatches : "+regExp.allMatches(json).toString());
     // print("firstMatch : "+regExp.firstMatch(json).toString());
      print("hasMatch : "+regExp.hasMatch(json).toString());

      regExp = RegExp(r'icoUpGreen');//new RegExp(r"/[0-9]+/");
      //print("stringMatch : "+regExp.stringMatch(json).toString());
      String signal = regExp.stringMatch(json).toString();
      print("Signal : "+signal);
        
     // print("allMatches : "+regExp.allMatches(json).toString());
     // print("firstMatch : "+regExp.firstMatch(json).toString());
      print("hasMatch : "+regExp.hasMatch(json).toString());
      if ((regExp.hasMatch(json)) == false){
          print("Green-Down");//Down
      }else{
          print("Red-Up");//Up
      }


   


/*
      RegExp regExp1 = new RegExp(r"^WS{1,2}:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:56789",caseSensitive: false,multiLine: false,);
      print("allMatches : "+regExp1.allMatches("WS://127.0.0.1:56789").toString());
      print("firstMatch : "+regExp1.firstMatch("WS://127.0.0.1:56789").toString());
      print("hasMatch : "+regExp1.hasMatch("WS://127.0.0.1:56789").toString());
      print("stringMatch : "+regExp1.stringMatch("WS://127.0.0.1:56789").toString());
*/

  /*    
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
  */
//////////////////////////////
}








  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body:GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            color: Colors.yellowAccent,
            height: double.infinity, // tambahkan property berikut
            child: Center(
              child: Text("1", style: TextStyle(fontSize: 24.0),),
            ),
          ),
          Container(
            color: Colors.blueAccent,
            height: double.infinity, // tambahkan property berikut
            child: Center(
              child: Text("2", style: TextStyle(fontSize: 24.0),),
            ),
          ),
          Container(
            color: Colors.brown,
            height: double.infinity, // tambahkan property berikut
            child: Center(
              child: Text("3", style: TextStyle(fontSize: 24.0),),
            ),
          ),
          Container(
            color: Colors.orange,
            height: double.infinity, // tambahkan property berikut
            child: Center(
              child:Row(children: <Widget>[
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0,
                    runSpacing: 0.0,
                    direction: Axis.horizontal,
                    children: _chipList,
                  ),
                ),
                //_addChip("test"),// Text("4", style: TextStyle(fontSize: 24.0),),
            ],)
            ),
          ),
          
        ],
      ),
      
    ),
    );   
    
  }
}