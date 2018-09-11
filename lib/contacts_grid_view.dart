import 'package:flutter/material.dart';

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
                style: TextStyle(
                    fontSize:
                        MediaQuery.of(context).size.width <= 800 ? 10.0 : 15.0),
              ),
            ),
          ),
          child: new Container(
            margin:
                EdgeInsets.only(top: 0.0, bottom: 15.0, left: 0.0, right: 0.0),
            child: new Icon(Icons.account_circle,
                color: const Color(0xFF000000), size: 50.0),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
