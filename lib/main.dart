import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:localstorage/key_finder_interface.dart';





void main() {
  debugPaintSizeEnabled = false;
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    
  @override
  Widget build(BuildContext context) {
    KeyFinder keyFinder = KeyFinder();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: _MyAppStateWiget(
          keyFinder: keyFinder,
        ),
      ),
    );
  }
}

class _MyAppStateWiget extends StatefulWidget {
  final KeyFinder keyFinder;

  _MyAppStateWiget({this.keyFinder});
  @override
  _MyAppWigetState createState() => _MyAppWigetState();
}


class _MyAppWigetState extends State<_MyAppStateWiget> {
  int _counter = 0;
  String load;
  Future post;
  var _chipListfast = List<Chip>();
  var _chipList = List<Chip>();
  var _keyNumber = 0;
  String price ="";
  String codename;//="Null to String";
  //String codename=""  


  @override
  void initState() {
    super.initState();
    //post = fetch(price);
    //webKeyFinder()
   
    _addChipfast("Nikkei 23300");
    _addChipfast("Newyork 27000");
    _addChipfast("Profit 150,000  350,000");

    widget.keyFinder.setKeyValue("6758","SONY-1995-200");//save to name,price,stock
    load = widget.keyFinder.getKeyValue("6758");//load
    print(load);
    fetch(load,"6758");
    
   
    
    _addChip(load ?? "NonData");
    _addChip("4");
    _addChip("5");
    _addChip("6");
   
    
  }

  
  
  //Incrementing counter after click
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }

  //Incrementing counter after click
  _decrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) - 1;
      prefs.setInt('counter', _counter);
    });
  }

  

  
  _deleteCounter(String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyword);
    _decrementCounter();//save to countDown
  }
  


void _addChipfast(String text) {
    var chipKey = Key('chip_key_$_keyNumber');
    _keyNumber++;
        
    _chipListfast.add(
      Chip(
        key: chipKey,
        backgroundColor:  Colors.orange,
        elevation: 4,
        //shadowColor: Colors.white,
        padding: EdgeInsets.all(4),
        avatar: CircleAvatar(
          backgroundColor: Colors.green,//.grey.shade800,
          child: Text(_keyNumber.toString()),
        ),
        label: Text(text,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        //onDeleted: () => _deleteChip(chipKey),
      ),
    );
   }


void _addChip(String text) {
    var chipKey = Key('chip_key_$_keyNumber');
    _keyNumber++;
          
    _chipList.add(
      Chip(
        key: chipKey,
        backgroundColor:  Color(0XFF12445D),
        elevation: 4,
        shadowColor: Colors.white,
        padding: EdgeInsets.all(4),
        avatar: CircleAvatar(
          backgroundColor: Colors.red,//.grey.shade800,
          child: Text(_keyNumber.toString()),
        ),
        label: Text(text,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onDeleted: () => _deleteChip(chipKey),
      ),
    );

  }


 

  
  void _deleteChip(Key chipKey) {
    setState(() => _chipList.removeWhere((Widget w) => w.key == chipKey));
  }



  loadData() async {
    String responce ="6758,200,1665\n9837,200,712\n6976,200,1746\n6753,0,0\n";
    List prices = json.decode(responce);
    _incrementCounter();

    for(String price in prices) {
      
      //fetch(price);
     // _addChip("SONY"+" 1,234");
    }
  }

  static List<Price> parse(var responce)
  {
    List<Price> prices = new List<Price>(); //ｺﾝｽﾄﾗｸﾀ
    var list = responce.split("\n"); 
              
    for( String row in list ) {
      if (row.isNotEmpty){
        var lista = row.split(",");  
                  
        Price p = new Price();
        p.code = lista[0];//企業コード
        p.stocks = lista[1];//保有数
        p.itemprice = lista[2];//購入単価
                  
        prices.add(p);
        print('Finance=${list.indexOf(row)}: $row');
      }
    }                   
    return prices;
  }








Future fetch(String load, String key) async {
  String ret;

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
      setState(() {
        ret = regExp.stringMatch(json).toString();
        load = ret;
        print("load : "+load);
      });
      
      print("StockPrice : "+ret);
      
      var intprice;
      try {
            intprice = int.parse(ret.replaceAll(",", "")); 
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
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
  */

}

  Widget _titleArea() {    
      return Container(
              color: Color(0xFF0B4050),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    runSpacing: 0.0,
                    direction: Axis.horizontal,
                    children: _chipListfast,
                  ),
                ),
                ],
              ),
      ); 
  }


bool _active = false;

void _changeSwitch(bool e) => setState(() => _active = e);

Widget _titleArea1() {
  return Container(
    color: Color(0xFF0B4050),
    //margin: EdgeInsets.all(10.0),
    child: Row(    // 1行目
      children: <Widget>[
        Expanded(  // 2.1列目
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(  // 3.1.1行目
                margin: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "Reload",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              Container(  // 3.1.2行目
                child: Text(
                  "Osaka, Japan",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        Icon(  // 2.2列目
          Icons.star,
          color: Colors.red,
        ),
        //Text('41'),
        Switch(
            value: _active,
            activeColor: Colors.orange,
            activeTrackColor: Colors.red,
            inactiveThumbColor: Colors.blue,
            inactiveTrackColor: Colors.green,
            onChanged: _changeSwitch,
          ) // 2.3列目
      ],
    )
  );
}


Widget _titleArealg(){
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          
         child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0,
                    runSpacing: 0.0,
                    direction: Axis.horizontal,
                    children: _chipList,
                  ),
        );
}


Widget _buttonArea() {
  return Container(
      color: Colors.black,
      margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Row( // 1行目
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildButtonColumn(Icons.call, "CALL"), // 2.1
          _buildButtonColumn(Icons.near_me, "ROUTE"), // 2.2
          _buildButtonColumn(Icons.share, "SHARE") // 2.3
        ],
      ));
}
 
Widget _buildButtonColumn(IconData icon, String label) {
  final color = Theme.of(context).primaryColor;
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(icon, color: color), // 3.1.1
      Container( // 3.1.2
        margin: const EdgeInsets.only(top: 8.0),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color),
        ),
      )
    ],
  );
}

Widget _descriptionArea() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Text('''
The Neko is very cute. The Neko is super cute. Neko has been sleeping during the day time. She gets up in the evening. she is playing around at night. She nestles up to me when I get a snack. She gets angly when I pick herup. She cries out like end of the world when I take her to the bathroom. When I am asleep she goes on. Therefore, sometimes, I can be apologized.
          '''),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
        return MaterialApp(
        home: Scaffold(
          //appBar: AppBar(
          //title: Text('Fetch Data Example'),
        //),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => setState(() => _addChip(load)),
        ),
        body:SafeArea(
              child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.max,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                //Expanded(
               
                //alignment: Alignment.topCenter,
                //width: 1.7976931348623157e+308,
                //height: 100.0,
                //child:
                _titleArea(),
              //),
              //Expanded(
                //child:
                Divider(height: 2.0,color: Colors.purple),
              //),
              Container(
                //color: Colors.black,
                child:_titleArea1(),
              ),
              Expanded(
                 flex: 6,
                //alignment: Alignment.center,
                //height: 600.0,
                //color: Colors.black,
                child:
                _titleArealg(),
              ),
              Expanded(
                //flex: 2,
                child:
                _buttonArea(),
                //alignment: Alignment.bottomCenter,
              ),
              //_descriptionArea(),
            ],
          ),
        ),
      ),
    );
  }

}


class Price
    {
        String code ;//会社名コード
        String name;//会社名*
        var stocks;//保有数*
        dynamic itemprice;//購入価格*
        double realprice;//現在値**
        String prevday;//前日比±**
        String percent; //前日比％**
        String polar; //上げ下げ(+ or -)
        dynamic ayAssetprice;//保有数* 購入価格 = 投資総額
        dynamic realValue;//利益総額
       
        dynamic investmen;//投資額
        dynamic investmens;//投資総額
        dynamic uptoAsset;//個別利益
        dynamic totalAsset;//現在評価額合計
       
        double gain;//損益
        
        int idindex;

       
         //Price(this.code, this.stocks, this.itemprice,this.name,this.realValue,this.prev_day,this.percent );
    }
/*
class WebKeyFinder implements KeyFinder {

  WebKeyFinder() {
    windowLoc = window;
    print("Widnow is initialized");
    // storing something initially just to make sure it works. :)
    windowLoc.localStorage["MyKey"] = "I am from web local storage";
  }

  String getKeyValue(String key) {
    return windowLoc.localStorage[key];
  }

  void setKeyValue(String key, String value) {
    windowLoc.localStorage[key] = value;
  }  
}
*/