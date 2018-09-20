import 'package:contacts_json/models/post.dart';
import 'package:flutter/material.dart';

// *********************************************************
// * Copyright (C) 2018 Paul Hammant <paul@hammant.org>    *
// *                                                       *
// * All rights reserved. This file is proprietary and     *
// * confidential and can not be copied and/or distributed *
// * without the express permission of Paul Hammant        *
// *********************************************************

class ContactsGridView extends StatefulWidget {
  ContactsGridView(
      {Key key,
      @required this.contacts,
      this.selectedItem,
      this.height,
      this.crossAxisCount,
      @required this.callback,
      @required this.onRefreshCallback})
      : super(key: key);
  final List<Post> contacts;
  final String selectedItem;
  final Function(String) callback;
  final VoidCallback onRefreshCallback;

  final double height;
  final int crossAxisCount;

  @override
  State<StatefulWidget> createState() {
    return _ContactsGridView(); // TODO: implement createState
  }
}

class _ContactsGridView extends State<ContactsGridView> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: widget.height,
      child: RefreshIndicator(
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: true,
          //physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0),
          itemCount: widget.contacts.length,
          itemBuilder: (context, index) {
            return CardItem(
              item: index,
              contacts: widget.contacts,
              onTap: () {
                String selected =
                    widget.contacts[index].name == widget.selectedItem
                        ? null
                        : widget.contacts[index].name;
                setState(() {
                  widget.callback(selected);
                });
              },
              selected: widget.selectedItem == widget.contacts[index].name,
            );
          },
        ),
        onRefresh: widget.onRefreshCallback,
      ),
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
    BorderSide border  = BorderSide(
      color: selected ? Colors.blueAccent : Colors.grey,
      width: selected ? 2.0 : 1.0,
    );
    double elevation = 0.0;

    return new GestureDetector(
      child: new Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          side: border
        ),
        elevation: elevation,
        child: new GridTile(
          footer: Center(
            child: new Text(
              contacts[item].name,
              style: TextStyle(
                  fontSize:
                  MediaQuery.of(context).size.width <= 800 ? 12.0 : 15.0),
            ),
          ),
          child: new AspectRatio(
            aspectRatio: 1.0,
            child: new Container(
              margin: EdgeInsets.all(15.0),
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                  image: new DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.topCenter,
                    image: new NetworkImage(contacts[item].pic.trim()),
                  )),
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
