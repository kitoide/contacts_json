import 'dart:async';
import 'dart:convert';

import 'package:contacts_json/models/post.dart';
import 'package:contacts_json/widgets/contacts_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// *********************************************************
// * Copyright (C) 2018 Paul Hammant <paul@hammant.org>    *
// *                                                       *
// * All rights reserved. This file is proprietary and     *
// * confidential and can not be copied and/or distributed *
// * without the express permission of Paul Hammant        *
// *********************************************************

class SendOrRequest extends StatefulWidget {
  SendOrRequest({Key key, this.title, this.url}) : super(key: key);
  final String title;
  final String url;

  @override
  _SendOrRequest createState() => _SendOrRequest();
}

class _SendOrRequest extends State<SendOrRequest> {
  String _selectedItem;
  List<Post> contacts;
  static String _orderBy = "Most recent";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
        padding: EdgeInsets.all(10.0),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              alignment: Alignment.topCenter,
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
              alignment: Alignment.topCenter,
            ),
            new Container(
              alignment: Alignment.center,
              child: new FutureBuilder<List<Post>>(
                future: fetchContacts(widget.url, http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  contacts = snapshot.data;
                  orderBy();
                  //contacts.sort((a,b)=>a.)
                  return snapshot.hasData
                      ? new ContactsGridView(
                    contacts: contacts,
                    height: MediaQuery.of(context).size.height - 300,
                    crossAxisCount: MediaQuery.of(context).orientation ==
                        Orientation.portrait
                        ? 4
                        : 6,
                    selectedItem: _selectedItem,
                    callback: (value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    },
                    onRefreshCallback: _handleRefresh,
                  )
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
            new Container(
              alignment: Alignment.bottomCenter,
              child: _selectedItem != null
                  ? new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new RaisedButton(
                          color: Colors.blueAccent,
                          elevation: 0.2,
                          textColor: Colors.white,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  new AlertDialog(
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
                              new Icon(Icons.cloud_upload, size: 15.0),
                              new Text(" ${widget.title}"),
                            ],
                          ),
                          textTheme: ButtonTextTheme.accent,
                        ),
                      ],
                    )
                  : null,
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

  Future<List<Post>> parseContacts(String responseBody) async {
    final parsed =
    json.decode(responseBody)["contacts"].cast<Map<String, dynamic>>();

    List<Post> list  = parsed.map<Post>((json) =>
        Post.fromJson(json)
    ).toList();

    return list;
  }

  Future<List<Post>> fetchContacts(String url, http.Client client) async {
    final response = await client
        .get(url);

    return parseContacts(response.body);
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

  Future<Null> _handleRefresh() async {
    Future<List<Post>> fut = fetchContacts(widget.url, http.Client());
    fut
        .then((value) => (setState(() {
      contacts = value;
    })))
        .catchError((error) => {});

    await new Future.delayed(new Duration(seconds: 3));
  }


}
