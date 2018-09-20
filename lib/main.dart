import 'package:contacts_json/pages/send_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// *********************************************************
// * Copyright (C) 2018 Paul Hammant <paul@hammant.org>    *
// *                                                       *
// * All rights reserved. This file is proprietary and     *
// * confidential and can not be copied and/or distributed *
// * without the express permission of Paul Hammant        *
// *********************************************************

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Contacts',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Select type"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new RaisedButton(
                color: Colors.blueAccent,
                elevation: 0.2,
                textColor: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SendOrRequest(
                              url:
                                  'https://paul-hammant.github.io/json_doc/contacts.json',
                              title: 'Send Documents',
                            )),
                  );
                },
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.cloud_upload, size: 15.0),
                    new Text(" Send Document"),
                  ],
                ),
                textTheme: ButtonTextTheme.accent,
              ),
              //////////////////////////////
              new RaisedButton(
                color: Colors.blueAccent,
                elevation: 0.2,
                textColor: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SendOrRequest(
                              url:
                                  'https://paul-hammant.github.io/json_doc/contacts2.json',
                              title: 'Request Documetns',
                            )),
                  );
                },
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.cloud_download, size: 15.0),
                    new Text(" Request Documents"),
                  ],
                ),
                textTheme: ButtonTextTheme.accent,
              )
            ],
          ),
        ),
      ),
    );

//      new SendDocuments(title: 'Send Documents',
//          url:"https://paul-hammant.github.io/json_doc/contacts.json"),
  }
}
