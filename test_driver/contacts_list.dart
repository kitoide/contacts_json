import 'package:contacts_json/ContactsGridView.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Post> contacts = new List<Post>();
    contacts.add(new Post(lastActive: 12312312, name: "Test", times: 6434234));
    contacts
        .add(new Post(lastActive: 76543555, name: "Test 2", times: 6434233));
    contacts
        .add(new Post(lastActive: 76543554, name: "Test 3", times: 6434232));
    contacts
        .add(new Post(lastActive: 76543553, name: "Test 4", times: 6434231));
    contacts
        .add(new Post(lastActive: 76543552, name: "Test 5", times: 6434236));

    return new MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'My Contacts',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("My Contacts"),
        ),
        body: new Column(
          children: <Widget>[
            new ContactsGridView(
                contacts: contacts,
                height: 500.0,
                crossAxisCount: 4,
                callback: (value) {},
                onRefreshCallback: () {})
          ],
        ),
      ),
    );
  }
}