import 'package:contacts_json/models/post.dart';
import 'package:contacts_json/widgets/contacts_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();

  List<Post> contacts = new List<Post>();
  contacts.add(new Post(lastActive: 12312312, name: "Test", times: 6434234));
  contacts.add(new Post(lastActive: 76543555, name: "Test 2", times: 6434233));
  contacts.add(new Post(lastActive: 76543554, name: "Test 3", times: 6434232));
  contacts.add(new Post(lastActive: 76543553, name: "Test 4", times: 6434231));
  contacts.add(new Post(lastActive: 76543552, name: "Test 5", times: 6434236));

  runApp(
    new MaterialApp(
      color: Colors.deepOrange,
        home: new ContactsGridView(
          contacts: contacts,
          height: 500.0,
          crossAxisCount: 4,
          callback: (value) {},
          onRefreshCallback: () {},
        ),
    )
  );
}
