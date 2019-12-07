import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs.dart';
//import 'key_finder_interface.dart';




void main() {
  debugPaintSizeEnabled = false;// runApp関数
  runApp(MyApp());
}

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _MyAppStateWiget(title: 'Flutter Demo Home Page'),
    );
  }
}

class _MyAppStateWiget extends StatefulWidget {
  _MyAppStateWiget({Key key, this.title}) : super(key: key);
  final String title;

  //_MyAppStateWiget();
  @override
  _MyAppWigetState createState() => _MyAppWigetState();
}


class _MyAppWigetState extends State<_MyAppStateWiget> {

List<String> codeItems = [];//codekey
List<String> stockItems = [];
List<String> valueItems = [];//stock and value

bool _validateCode = false;
bool _validateStock = false;
bool _validateValue = false;
  
final TextEditingController codeCtrl = TextEditingController();
final TextEditingController stockCtrl = TextEditingController();
final TextEditingController valueCtrl = TextEditingController();  
  
  
  
  
  int _counter = 0;
  String load;
  Future post;
  var _chipListfast = List<Chip>();
  var _chipList = List<Chip>();
  var _keyNumber = 0;
  String price ="";
  String codename;//="Null to String";
  //String codename=""  

void _init() async {
    await SharePrefs.setInstance();
        
    codeItems = SharePrefs.getCodeItems();
    stockItems = SharePrefs.getStockItems();
    valueItems = SharePrefs.getValueItems();

    loadData();
    setState(() {});
}



  @override
  void initState() {
    _init();
    super.initState();


    //loadData();
    //print(codeItems ?? "Null Data");
    _addChipfast("1234");
    _addChipfast("5678");
    _addChipfast("9012");
       
    //_addChip(load ?? "NonData","","");
    _addChip("7658"," 1,000"," +10.0%");
    _addChip("5555"," 5,555"," +10.0");
    _addChip("7658"," 1,000"," +10.0%");
    _addChip("7658"," 1,000"," +10.0%");
    _addChip("7658"," 1,000"," +10.0%"); 
  }

  @override
  void dispose() {
    //eCtrl.dispose();
    codeCtrl.dispose();
    stockCtrl.dispose();
    valueCtrl.dispose();

    super.dispose();
  }
  /*
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
  */


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


void _addChip(String code,String value, String resio) {
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
        label: Text(code.toString() + value.toString()+resio.toString(),style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onDeleted: () => _deleteChip(chipKey),
      ),
    );

  }


 

  
  void _deleteChip(Key chipKey) {
    setState(() => _chipList.removeWhere((Widget w) => w.key == chipKey));
  }



  loadData() async {
    //String responce ="6758,200,1665\n9837,200,712\n6976,200,1746\n6753,0,0\n";
    List<String> codes = codeItems;
    //_incrementCounter();

    for(String code in codes) {
      
      fetch(code);
      _addChip(code ," 100" ," 1,234");
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








Future fetch(String load) async {
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
    height: 35.0,
    color: Color(0xFF0B4050),
    //margin: EdgeInsets.all(10.0),
    padding: EdgeInsets.only(top:5.0,bottom:5.0),
    child: Row(    // 1行目
      children: <Widget>[
        Expanded(child:
          Container(
            margin: EdgeInsets.only(left:10.0,right: 10.0),  
            padding: EdgeInsets.all(1.0),
          //height: 70.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey,
          ),
          child:TextField(
            controller: codeCtrl,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "code",
              hintStyle:TextStyle(color: Colors.white,fontSize: 12.0, fontWeight: FontWeight.bold),
              errorText: _validateCode ? 'The CodeNumber input is empty.' : null,
              contentPadding: const EdgeInsets.only(
                left: 15.0, bottom: 15.0, top: 15.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellowAccent),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            autocorrect: true,
            onSubmitted: (text) {
              if (text.isEmpty) {
                _validateCode = true;
                setState(() {});
              } else {
                _validateCode = false;
                codeItems.add(text);
                codeCtrl.clear();
              }
            },
          ),
        ),
        ),
                Expanded(child:          
                  Container(
                    // height: 70.0,
                    margin: EdgeInsets.only(left:10.0,right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey,
                    ),
                    child: TextField(
                      controller: stockCtrl,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "stock",
                        hintStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                        errorText: _validateStock ? 'The Stock input is empty.' : null,
                        contentPadding: const EdgeInsets.only(
                        left: 25.0, bottom: 15.0, top: 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      autocorrect: true,
                      onSubmitted: (text) {
                        if (text.isEmpty) {
                          _validateStock = true;
                          setState(() {});
                        } else {
                          _validateStock = false;
                          stockItems.add(text);
                          SharePrefs.setStockItems(stockItems).then((_) {
                            setState(() {});
                          });
                            stockCtrl.clear();
                        }
                      },
                    ),
                  ),
                ),
                Expanded(child: 
                  Container(
                    //height: 70.0,
                    margin: EdgeInsets.only(left:10.0,right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey,
                    ),
                    child: TextField(
                      style:TextStyle(color: Colors.white.withOpacity(0.6),fontWeight: FontWeight.bold),                
                      controller: valueCtrl,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "value",
                        hintStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                        errorText: _validateValue ? 'The Value input is empty.' : null,
                        contentPadding: const EdgeInsets.only(
                        left: 25.0, bottom: 15.0, top: 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      autocorrect: true,
                      onSubmitted: (text) {//TextFieldからの他のコールバック
                      if (text.isEmpty) {
                        _validateValue = true;
                        setState(() {});
                      } else {
                        _validateValue = false;
                        valueItems.add(text);
                        SharePrefs.setValueItems(valueItems).then((_) {
                          setState(() {});
                        });
                        valueCtrl.clear();
                      }
                    },
                  ),
                ),
              ),
              InkWell(
                child: Icon(
                  Icons.add_circle,
                  color: Colors.blueAccent,
                ),
                onTap: () {
                  if (/*eCtrl.text.isEmpty ||*/ codeCtrl.text.isEmpty || stockCtrl.text.isEmpty || valueCtrl.text.isEmpty) {
                              //if (eCtrl.text.isEmpty) _validate = true;
                    if (codeCtrl.text.isEmpty)  _validateCode= true;
                    if (stockCtrl.text.isEmpty)  _validateStock = true;
                    if (valueCtrl.text.isEmpty)  _validateValue = true;
                    setState(() {});
                  } else {
                    _validateCode = false;
                    _validateStock = false;
                    _validateValue = false;
                    codeItems.add(codeCtrl.text);stockItems.add(stockCtrl.text);valueItems.add(valueCtrl.text);
                    SharePrefs.setCodeItems(codeItems).then((_) {
                      setState(() {});
                    });
                    SharePrefs.setStockItems(stockItems).then((_) {
                      setState(() {});
                    });
                    SharePrefs.setValueItems(valueItems).then((_) {
                      setState(() {});
                    });
                    loadData();
                    codeCtrl.clear();stockCtrl.clear();valueCtrl.clear();
                  }
                }
              ),
              Switch(
                value: _active,
                activeColor: Colors.orange,
                activeTrackColor: Colors.red,
                inactiveThumbColor: Colors.blue,
                inactiveTrackColor: Colors.green,
                onChanged: _changeSwitch,
              )  
            ],
          )
        );
      }


Widget _titleArealg(){
        return Container( 
          decoration: BoxDecoration(
            color: Color(0xFF0B4050),
          ),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),   
          child:
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 10.0,
              runSpacing: 10.0,
              direction: Axis.horizontal,
              children: _chipList,
            ),
          ),
        );
}


Widget _buttonArea() {
  return Container(
      color: Color(0xFF0B4050),//Colors.black,
      //margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
    mainAxisAlignment: MainAxisAlignment.start,
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
          onPressed: () => setState(() => _addChip(load,"","")),
        ),
        body:SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _titleArea(),
                _titleArea1(),           
                Expanded(
                  flex: 5,
                  child: _titleArealg(),
                ),
                Expanded(
                  child: _buttonArea(),
                ),
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
