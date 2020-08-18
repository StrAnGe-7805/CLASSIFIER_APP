import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Classifier App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Classifier app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final inputCon = new TextEditingController();
  final outputCon = new TextEditingController();
  int index = 3;

  void postJsonData(String text) async {
    final payload = jsonEncode({'input': text});
    const headers = {'Content-Type': 'application/json'};
    await http.post('http://127.0.0.1:5000/todo/api/v1.0/tasks',
        headers: headers, body: payload);
    index = index + 1;
  }

  Future<String> getJsonData(String text) async {

    final payload = jsonEncode({'input': text});
    const headers = {'Content-Type': 'application/json'};
    await http.post('http://127.0.0.1:5000/todo/api/v1.0/tasks',
        headers: headers, body: payload);

    var response = await http
        .get('http://127.0.0.1:5000/todo/api/v1.0/tasks/' + text);

    //print('http://127.0.0.1:5000/todo/api/v1.0/tasks/' + index.toString());

    var o = json.decode(response.body);

    setState(() {
      outputCon.text = o["task"]["output"];
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Welcome to Flutter",
        home: new Material(
            child: new Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: new Container(
                  child: new Center(
                      child: new Column(children: [
                    new Padding(padding: EdgeInsets.only(top: 140.0)),
                    new TextFormField(
                      controller: inputCon,
                      decoration: new InputDecoration(
                        labelText: "INPUT",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 50.0)),
                    new RaisedButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.redAccent,
                      onPressed: () {
                        getJsonData(inputCon.text);
                      },
                      child: Text("PREDICT"),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 50.0)),
                    new TextFormField(
                      controller: outputCon,
                      decoration: new InputDecoration(
                        labelText: "OUTPUT",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                  ])),
                ))));
  }
}
