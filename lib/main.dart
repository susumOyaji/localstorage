import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';




void main() {
  debugPaintSizeEnabled = true;
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

//void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;
  String load;
  Future post;
  var _chipListfast = List<Chip>();
  var _chipList = List<Chip>();
  var _keyNumber = 0;
  String price ="";

  @override
  void initState() {
    super.initState();
    //post = fetch(price);
    _saveString("6758","SONY");//save
    _loadString("6758");//load
    
    

    _addChipfast("Nikkei 23300");
    _addChipfast("Newyork 27000");
    _addChipfast("Profit 150,000  350,000");
    
    
    _addChip("Taiyo");
    _addChip("3");
    _addChip("4");
    _addChip("5");
    _addChip("6");
        //print("out");
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

  //Loading counter value on start
  void _loadString( String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      load = prefs.getString(keyword) ?? "null";//load
      print(load);
    });
  }

  //Incrementing counter after click
  void _saveString(String keyword,String keydata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        prefs.setString(keyword, keydata);//save
        _incrementCounter();//save to countUp
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
        shadowColor: Colors.white,
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
        backgroundColor:  Colors.blueAccent,
        elevation: 4,
        shadowColor: Colors.white,
        padding: EdgeInsets.all(4),
        avatar: CircleAvatar(
          backgroundColor: Colors.red,//.grey.shade800,
          child: Text(_keyNumber.toString()),
        ),
        label: Text(text,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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





Future fetch(price) async {
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
        price = regExp.stringMatch(json).toString();
      });
      
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

}

  Widget _titleArea() {    
      return Container(
              color: Colors.black,
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


Widget _titleArealg(){
        return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10.0,
                    runSpacing: 0.0,
                    direction: Axis.horizontal,
                    children: _chipList,
                  ),
                ),
              ],
            ),
          ],
        ),
      
    );
              
  
}
      
  



Widget _titleArea1() {
  return Container(
    margin: EdgeInsets.all(16.0),
    child: Row(    // 1行目
      children: <Widget>[
        Expanded(  // 2.1列目
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(  // 3.1.1行目
                margin: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "Neko is So cute.",
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
        Text('41'),  // 2.3列目
      ],
    )
  );
}


Widget _buttonArea() {
  return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Row( // 1行目
        crossAxisAlignment: CrossAxisAlignment.start,
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
          appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => setState(() => _addChip("Add")),
        ),
        body:Column(
          children: <Widget>[
            _titleArea(),
            _titleArealg(),
            //_titleArea1(),
            //_buttonArea(),
            //_descriptionArea(),
          ],
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