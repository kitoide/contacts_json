/*
  Developed in Brazil with all love, thanks for the trust.
  Sincerely, Thiago Souza - TDesign Technology
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'contacts.dart';
import 'package:http/http.dart' as http;

void main() {

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Contacts',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Send Document'),
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
  String _selectedItem;
  List<Post> contacts;
  static String _orderBy = "Most recent";

  @override
  Widget build(BuildContext context) {
    var heightPart = MediaQuery.of(context).size.height / 5;



    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
        padding: EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            new Container(
              height: heightPart / 3,
              child: new Column(
                children: <Widget>[
                  Center(
                    child: new Text(
                      "Select contact to send document to:",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  new Divider(color: Colors.lightBlue),
                ],
              ),
            ),
            new Container(
              height: heightPart / 3,
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "Your contacts",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0),
                    ),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: new Text(
                              "Sort by: ",
                              style: new TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          new DropdownButton<String>(
                            onChanged: popupButtonSelected,
                            value: _orderBy,
                            style: new TextStyle(
                                fontSize: 12.0, color: Colors.black),
                            items: <String>[
                              'Most recent',
                              'Frequency',
                              'Alphabetical'
                            ].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ]),
                  ]),
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
            ),
            new Container(
              height: _selectedItem == null ? heightPart * 3.40 : heightPart * 3.0,
              child: new FutureBuilder<List<Post>>(
                future: fetchPhotos(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  contacts = snapshot.data;
                  orderBy();
                  //contacts.sort((a,b)=>a.)
                  return snapshot.hasData
                      ? _postList(contacts: contacts)
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
            new Container(
              height: _selectedItem != null ? heightPart/2.5 : 0.0,
              alignment: FractionalOffset.center,
              margin: EdgeInsets.only(top: 10.0),
              child: _selectedItem != null ? new RaisedButton(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),

                  onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => new AlertDialog(
                                title: new Column(
                                  children: <Widget>[
                                    new Text(
                                      "Send doc pressed!",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
                                    ),
                                  ],
                                ),
                                content: new Text(
                                  _selectedItem + " selected",
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: new Text("OK"))
                                ],
                              ),
                        );
                      },
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Icon(
                              Icons.cloud_upload,
                              color: const Color(0xFF000000),
                              size: 30.0),
                          new Text(" Send Document"),
                        ],
                      ),
                      textTheme: ButtonTextTheme.accent,
                    ):null,

            ),
          ],
        ),
      ),
    );
  }

  void popupButtonSelected(String value) {
    setState(() {
      _orderBy = value;
      orderBy();
    });
  }

  void orderBy() {
    if (contacts != null) {
      if (_orderBy == "Most recent") {
        contacts.sort((a, b) {
          return b.lastActive.compareTo(a.lastActive);
        });
      }
      if (_orderBy == "Frequency") {
        contacts.sort((a, b) {
          return b.times.compareTo(a.times);
        });
      }
      if (_orderBy == "Alphabetical") {
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      }
    }
  }

  Widget _postList({List<Post> contacts}) {
    return new Container(
      height: MediaQuery.of(context).size.height - 300,
      child: RefreshIndicator(
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: true,
          //physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 4 : 6,
              mainAxisSpacing: 4.0, crossAxisSpacing: 4.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return CardItem(
              item: index,
              contacts: contacts,
              onTap: () {
                setState(() {
                  _selectedItem = contacts[index].name == _selectedItem
                      ? null
                      : contacts[index].name;
                });
              },
              selected: _selectedItem == contacts[index].name,
            );
          },
        ),
        onRefresh: _handleRefresh,
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    Future<List<Post>> fut = fetchPhotos(http.Client());
    fut
        .then((value) => (setState(() {
              contacts = value;
            })))
        .catchError((error) => {});

    await new Future.delayed(new Duration(seconds: 3));
  }
}
