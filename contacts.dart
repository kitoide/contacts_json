import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<Post> parseContacts(String responseBody) {
  final parsed =
      json.decode(responseBody)["contacts"].cast<Map<String, dynamic>>();

  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}

Future<List<Post>> fetchPhotos(http.Client client) async {
  final response =
      await client.get("https://paul-hammant.github.io/json_doc/contacts.json");

  return parseContacts(response.body);
}

class Post {
  final String name;
  final int times;
  final int lastActive;

  Post({this.name, this.times, this.lastActive});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'],
      times: json['times'],
      lastActive: json['last_active'],
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem(
      {Key key,
      //@required this.animation,
      this.onTap,
      @required this.item,
      @required this.contacts,
      this.selected: false})
      : //assert(animation != null),
        assert(item != null && item >= 0),
        assert(selected != null),
        super(key: key);

  //final Animation<double> animation;
  final VoidCallback onTap;
  final int item;
  final List<Post> contacts;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Border border = Border.all(width: 0.0);
    double elevation = 0.0;

    if (selected) {
      border = Border.all(color: Colors.red, width: 2.0);
      elevation = 5.5;
    }
    return new GestureDetector(
      child: new Card(
        shape: border,
        elevation: elevation,
        child: new GridTile(
          footer: Center(
            child: Padding(
              padding: new EdgeInsets.all(5.0),
              child: new Text(
                contacts[item].name,
              ),
            ),
          ),
          child: new Container(
            margin:
                EdgeInsets.only(top: 0.0, bottom: 5.0, left: 0.0, right: 0.0),
            child: new Icon(Icons.account_circle,
                color: const Color(0xFF000000), size: 50.0),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
