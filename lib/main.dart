import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'shared_prefs.dart';

//import 'com.google.android.material:material:1.0.0-beta01'

//void main() {
//  runApp(MyApp());
//}

//void main() => runApp(new MyApp());
void main()=>runApp(new MyApp()); 



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // <- Debug の 表示を OFF
      //title: 'Flutter Demo',
      //theme: ThemeData(primarySwatch: Colors.blue,),
      home: _MyAppStateWiget(),
    );
  }
}

class _MyAppStateWiget extends StatefulWidget {
 // _MyAppStateWiget({Key key, this.title}) : super(key: key);
 // final String title;
  
  @override
  _MyAppWigetState createState() => _MyAppWigetState();
}

class _MyAppWigetState extends State<_MyAppStateWiget> {
  List<String> codeItems = []; //codekey
  List<String> stockItems = [];//stock
  List<String> valueItems = []; //value

  List<String> acquiredAssetsItems = [];//取得資産 stock x value
  List<String> valuableAssetsItems = [];//評価資産 stock X presentvalue
  List<String> acquiredAssetsSumString = [];
  List<String> valuableAssetsSumString = [];
  int acquiredAssetsSum = 0;//取得資産合計
  int valuableAssetsSum = 0;//評価資産合計


  String valueSum;
  String presentvalueSUm;

  bool _validateCode = false;
  bool _validateStock = false;
  bool _validateValue = false;

  final TextEditingController codeCtrl = TextEditingController();
  final TextEditingController stockCtrl = TextEditingController();
  final TextEditingController valueCtrl = TextEditingController();

  static String code; //
  static String presentvalue = "non"; //現在値
  static String changePriceRate = "non"; //前日比%
  static String changePriceValue = "non"; //前日比¥
  static bool signalstate = true; //Up or Down

  var _chipListfast = List<Chip>();
  var _chipList = List<InputChip>();
  var _keyNumber = 0;
  var _keyNumberfast = 0;
  String price = "";
  String codename; //="Null to String";
  int intprice=0;
  int index=0;
  bool purchase = false;
  String stringprice ="";
  String gain="0";

  void _init() async {
    await SharePrefs.setInstance();

    codeItems = SharePrefs.getCodeItems();
    stockItems = SharePrefs.getStockItems();
    valueItems = SharePrefs.getValueItems();
    acquiredAssetsItems = SharePrefs.getacquiredAssetsItems();//取得資産
    valuableAssetsItems = SharePrefs.getvaluableAssetsItems();



    await loadDatafast("998407.O");
    await loadDatafast("^DJI");
    
    await loadData();
    
  }

  @override
  void initState() {
    _init();

    super.initState();   
  }

  @override
  void dispose() {
    codeCtrl.dispose();
    stockCtrl.dispose();
    valueCtrl.dispose();
   
    super.dispose();
  }

  
 
    
    //_scrollController.positions(1.0);
  
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

 
  
  void _addChipfast(String code,String presentvalue, String beforeratio,String gain) {
    var chipKey = Key('chip_key_$_keyNumberfast');
    _keyNumberfast++;

     
    _chipListfast.add(
      Chip(
        key: chipKey,
        backgroundColor: Color(0XFF8069A1),
        elevation: 4,
        //shadowColor: Colors.white,
        padding: EdgeInsets.all(4),
        avatar: CircleAvatar(
          backgroundColor:  signalstate ? Colors.red : Colors.green,
        ),
        label: Text(code + presentvalue + beforeratio + gain,
          style: TextStyle(color: Color(0XFFACACAE),
            fontSize:12.0,
            fontWeight: FontWeight.bold)
        ),
      ),
    );
  }


  void _addChip(String code, String presentvalue, String deforerasio) {
    //var chipKey = Key('chip_key_$_keyNumber');
    var chipKey = Key("$_keyNumber");
    _keyNumber++;

    _chipList.add(
      InputChip(
        showCheckmark: false, 
        key: chipKey,
        backgroundColor: Color(0XFF12445D),
        elevation: 8,
        //shadowColor: Colors.white,
        padding: EdgeInsets.all(4),
        avatar: CircleAvatar(
          maxRadius: 10.0,
          backgroundColor:
              signalstate ? Colors.red : Colors.green,
          child: Text(_keyNumber.toString()),
        ),
        //onDeleted: () {
        //    setState(() {
              //_cast.removeWhere((Actor entry) {
              //  return entry.name == actor.name;
        //      });
            
       // },
        label: Text(code + " " + presentvalue + "  " + deforerasio,
            style: TextStyle(
                color: Color(0XFFACACAE),
                fontSize: 10.0,
                fontWeight: FontWeight.bold)
        ),
        //selected: true,//index,
        //onSelected: (bool selected) {
        //      setState(() {
        //        _reloadData();//_deleteChip(chipKey);
                //_value = selected ? index : null;
        //      });
        //    },
        //     onDeleted: () => state.deleteChip(profile),
        //onSelected: (_) => _msg(chipKey),//_reloadData(),
         
        //onSelected：() => _deleteChip(chipKey),
        onPressed:(){
           AlertDialog(
              title: Text("タイトル"),
              content: Text("メッセージメッセージメッセージメッセージメッセージメッセージ"),
              actions: <Widget>[
              // ボタン領域
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
              ],
          );
        },
        //deleteButtonTooltipMessage: "dellete",
        onDeleted: () => _deleteChip(chipKey),
      ),
    );
  }


  
  void _deleteChip(Key chipKey) {
    setState(() => _chipList.removeWhere((Widget w) => w.key == chipKey));
    ValueKey<String> listJsonData = chipKey;
    int _index = int.parse(listJsonData.value);
    
    codeItems.removeAt(_index);stockItems.removeAt(_index);valueItems.removeAt(_index);
    SharePrefs.setCodeItems(codeItems);SharePrefs.setStockItems(stockItems);SharePrefs.setValueItems(valueItems);
    setState(() {
      _keyNumber--;
      
    });
  }


  loadDatafast(String codes) async {
    //String responce ="6758,200,1665\n6976,400,1746\n395,0,0\n";
    //_incrementCounter();
    await fetch(codes);
    _addChipfast(code, "  "+presentvalue, "  "+changePriceRate,"");
    
  }

  loadDatGainsum()
  {
    _addChipfast("code", presentvalue, changePriceRate,gain);
  }



  loadData() async {
    //String responce ="6758,200,1665\n6976,400,1746\n395,0,0\n";
    //_incrementCounter();
    intprice=0;
    index=0;
    purchase = true;

    for (String codes in codeItems) {
      await fetch(codes);
      _addChip(code, presentvalue, changePriceRate);
    }
    
    _addChipfast("Gain:",gain,"   取得額: "+valueSum, "   評価額: "+presentvalueSUm);
  }


  
  addfetch(String codes) async {
    await fetch(codes);
    _addChip(codes, presentvalue, changePriceRate);
  }


  _reloadData() async {
    index=0;
    for (String codes in codeItems) {
      codes= codes+".T";
      await fetch(codes);
      //_addChip(code, presentvalue, beforeratio);
    }
    setState(() {
      
    });
  }

   String separation(int number){
      final matcher = new RegExp(r'(\d+)(\d{3})');

      String first_part = number.toString();
      while ((first_part).contains(matcher)) {
        first_part = (first_part.replaceAllMapped(matcher, (m) => '${m[1]},${m[2]}') );
      }
      print('first_part: $first_part');
      return first_part;
  }


  Future fetch(String codes) async {
    final response = await http.get(
        "https://stocks.finance.yahoo.co.jp/stocks/detail/?code="+codes);//+".T"); //^DJI
    final String json = response.body;
    String ret;
    String value;

 
    RegExp regExp = RegExp(r'<title>.+【');
    setState(() {
      ret = regExp.stringMatch(json).toString();//name
      ret = ret.replaceAll("<title>", "");
      code = ret.replaceAll("【", "");
    print("code-name : " + code);
    });

   
    //regExp = RegExp(r'[+-][0-9]{1,}.[0-9]{1,}.[+-]..[0-9]{1,}%.');//日経平均
    //regExp = RegExp(r'[0-9]{1,}[,][0-9]{1,}[.][0-9]{1,}');//DOW平均
    regExp = RegExp(r'[0-9]{1,},[0-9]{1,}'); //1,234;
    setState(() {
      value = regExp.stringMatch(json).toString();//現在値
      presentvalue = value;
    });
    print("StockPrice : " + value);
    print("string to int : " + intprice.toString());
    print("hasMatch : " + regExp.hasMatch(json).toString());
    

    //regExp = RegExp(r'[+-][0-9]{1,}.[+-]..[0-9]{1,}%.'); 
    //regExp = RegExp(r'[+-][0-9]{1,}.[0-9]{1,}.[+-]..[0-9]{1,}%.');//日経平均
    regExp = RegExp(r'["][+-][0-9]{1,}[.][0-9]{1,}');//DOW前日比¥
    setState(() {
      String change = regExp.stringMatch(json).toString();
      change = change.replaceAll('"', "");
      changePriceRate = change; //前日比%
      print("Change : " + changePriceRate);
    });
    print("Change : " + regExp.hasMatch(json).toString());

    regExp = RegExp(r'["][+-][0-9]{1,}[.][0-9]{1,}');//DOW前日比%
    setState(() {
      String change = regExp.stringMatch(json).toString();
      change = change.replaceAll('"', "");
      changePriceValue = change; //前日比%
      print("ChangeValue : " + changePriceRate);
    });
    print("ChangeValue: " + regExp.hasMatch(json).toString());




    if (purchase == true){
      try {
        intprice = intprice + int.parse(value.replaceAll(",", ""));//string for int
      } catch (exception) {
        intprice = 0;
      }
      acquiredAssetsItems.add((int.parse(stockItems[index]) * int.parse(valueItems[index])).toString());//取得資産
      
      try{
        valuableAssetsItems.add((int.parse(value.replaceAll(",", "")) * int.parse(stockItems[index])).toString());//評価資産
      }catch(exception){
        valuableAssetsItems.add("0");
      }

      setState(() {
        acquiredAssetsSum = acquiredAssetsSum + int.parse(acquiredAssetsItems[index]);//取得資産合計
        valueSum = separation(acquiredAssetsSum);
        acquiredAssetsSumString.add(valueSum.toString());

        valuableAssetsSum = valuableAssetsSum + int.parse(valuableAssetsItems[index]);//評価資産
        presentvalueSUm = separation(valuableAssetsSum);
        valuableAssetsSumString.add(presentvalueSUm.toString());

        gain = separation(valuableAssetsSum - acquiredAssetsSum);

      });
     
      index++;
    }


    regExp = RegExp(r'icoUpGreen'); //new RegExp(r"/[0-9]+/");
    String signal = regExp.stringMatch(json).toString();
    if (signal == "null") {
      signalstate = false;
    } else {
      signalstate = true;
    }
    print("Signal : " + signal);
    print("hasMatch : " + regExp.hasMatch(json).toString());
    if ((regExp.hasMatch(json)) == false) {
      print("Green-Down"); //Down
    } else {
      print("Red-Up"); //Up
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
              children:  _chipListfast,
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
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          // 1行目
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                //padding: EdgeInsets.all(1.0),
                //height: 70.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey,
                ),
                child: TextField(
                  controller: codeCtrl,
                  decoration: InputDecoration(
                    labelText: 'CodeNumber',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        //height: 1,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    errorText: _validateCode ? 'The CodeNumber input is empty.' : null,
                    contentPadding: const EdgeInsets.only(
                        left: 0.0, bottom: 15.0, top: 15.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellowAccent),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  autocorrect: false,
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
            Expanded(
              child: Container(
                // height: 70.0,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey,
                ),
                child: TextField(
                  controller: stockCtrl,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        //height: 1,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    errorText:
                        _validateStock ? 'The Stock input is empty.' : null,
                    contentPadding: const EdgeInsets.only(
                        left: 0.0, bottom: 15.0, top: 15.0),
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
            Expanded(
              child: Container(
                //height: 70.0,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey,
                ),
                child: TextField(
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.bold),
                  controller: valueCtrl,
                  decoration: InputDecoration(
                    labelText: "value",
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        //height: 1,
                        fontWeight: FontWeight.bold),
                   errorText:
                        _validateValue ? 'The Value input is empty.' : null,
                    contentPadding: const EdgeInsets.only(
                        left: 0.0, bottom: 15.0, top: 15.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  autocorrect: true,
                  onSubmitted: (text) {
                    //TextFieldからの他のコールバック
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
                  semanticLabel: "",
                ),
                onTap: () {
                  if (/*eCtrl.text.isEmpty ||*/ codeCtrl.text.isEmpty ||
                      stockCtrl.text.isEmpty ||
                      valueCtrl.text.isEmpty) {
                    //if (eCtrl.text.isEmpty) _validate = true;
                    if (codeCtrl.text.isEmpty) _validateCode = true;
                    if (stockCtrl.text.isEmpty) _validateStock = true;
                    if (valueCtrl.text.isEmpty) _validateValue = true;
                    setState(() {});
                  } else {
                    _validateCode = false;_validateStock = false;_validateValue = false;
                    codeItems.add(codeCtrl.text);
                    stockItems.add(stockCtrl.text);
                    valueItems.add(valueCtrl.text);
                    SharePrefs.setCodeItems(codeItems);
                    SharePrefs.setStockItems(stockItems);
                    SharePrefs.setValueItems(valueItems);
                    setState(() {
                      addfetch(codeCtrl.text);
                     
                    });
                            
                    codeCtrl.clear();stockCtrl.clear();valueCtrl.clear();
                  }
                }),
            Switch(
              value: _active,
              activeColor: Colors.orange,
              activeTrackColor: Colors.red,
              inactiveThumbColor: Colors.blue,
              inactiveTrackColor: Colors.green,
              onChanged: _changeSwitch,
            )
          ],
        ));
  }

  Widget _titleArealg() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0B4050),
      ),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
      child: SingleChildScrollView(
        //controller: 
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
        color: Color(0xFF0B4050), //Colors.black,
        //margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Row(
          // 1行目
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
        Container(
          // 3.1.2
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 12.0, fontWeight: FontWeight.w400, color: color),
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //appBar: AppBar(
        //title: Text('Fetch Data Example'),
        //),
        floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(Icons.refresh),
          onPressed: () => setState(() => _reloadData()),// _addChip("code", "", "")),
        ),
        body: SafeArea(
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

