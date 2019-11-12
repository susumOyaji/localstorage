import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future fetch() async {
   print("out1");
  final  response =
      //await http.get('https://jsonplaceholder.typicode.com/posts/1');
      await http.get("https://stocks.finance.yahoo.co.jp/stocks/detail/?code=6758.T");
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

      RegExp regExp = new RegExp(r'/stoksPrice/\w+');
      //String s = "http://example.com?id=some.thing.com&other=parameter; http://example.com?id=some1.thing.com";
      Iterable<Match> matches = regExp.allMatches(json);
      for (Match match in matches) {
        print(match.group(1));
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
//////////////////////////////
 



}






void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
Future post;

  @override
  void initState() {
    super.initState();
    post = fetch();
    print("out");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}