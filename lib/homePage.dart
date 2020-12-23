import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final Map profile;
  HomePage({Key key, @required this.profile}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(profile);
}

class _HomePageState extends State<HomePage> {
  final profile;
  _HomePageState(this.profile);
  int _selectedIndex = 0;
  List<Map> orders = [];

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'menu',
    ),
    Text(
      'favorite menu',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    print(profile);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: new EdgeInsets.only(top: 50.0),
                    child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    profile["picture"]["data"]["url"]))))),
                Padding(
                    padding: new EdgeInsets.only(top: 50.0, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile["name"],
                            style: TextStyle(
                                fontFamily: "Prompt",
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        Text("Member",
                            style:
                                TextStyle(fontFamily: "Prompt", fontSize: 15)),
                      ],
                    )),
              ],
            ),
            _selectedIndex == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        new Padding(
                            padding: new EdgeInsets.only(
                                top: 40.0, left: 50, bottom: 20),
                            child: Text("Menu ",
                                style: TextStyle(
                                    fontFamily: "Prompt", fontSize: 20))),

                        new Container(
                            width: 500,
                            height: 675,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      menu(
                                          context,
                                          54,
                                          "assets/images/menu/burger.jpg",
                                          "Burger",
                                          80),
                                      menu(
                                          context,
                                          65,
                                          "assets/images/menu/steak.jpg",
                                          "Steak",
                                          70)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      menu(
                                          context,
                                          80,
                                          "assets/images/menu/burger-fish.jpg",
                                          "Burger fish",
                                          70),
                                      menu(
                                          context,
                                          15,
                                          "assets/images/menu/friend-fried.jpg",
                                          "french fried",
                                          50)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      menu(
                                          context,
                                          23,
                                          "assets/images/menu/hotdog.jpg",
                                          "Hot dog",
                                          55),
                                      menu(
                                          context,
                                          40,
                                          "assets/images/menu/coke.jpg",
                                          "Coke",
                                          15)
                                    ],
                                  ),
                                ],
                              ),
                            ))
                        // ListView(children: [
                        //   // remaining stuffs
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [menu(context), menu(context)],
                        //   ),
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [menu(context), menu(context)],
                        //   ),
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [menu(context), menu(context)],
                        //   ),
                        // ]),
                      ])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        new Padding(
                            padding: new EdgeInsets.only(
                                top: 40.0, left: 50, bottom: 10),
                            child: Text("Your Orders ",
                                style: TextStyle(
                                    fontFamily: "Prompt", fontSize: 20))),
                        new Container(
                          width: 500,
                          height: 675,
                          child: ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text('${orders[index]["name"]}',
                                    style: TextStyle(fontFamily: "Prompt")),
                                subtitle: Text(
                                  '${orders[index]["price"]} Bath',
                                  style: TextStyle(fontFamily: "Prompt"),
                                ),
                                leading: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 44,
                                      minHeight: 44,
                                      maxWidth: 44,
                                      maxHeight: 44,
                                    ),
                                    child: Image.asset(
                                        '${orders[index]["picture"]}',
                                        fit: BoxFit.cover)),
                              );
                            },
                          ),
                        )
                      ])
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 5,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox),
              label: 'Orders',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAlertDialog(context);
        },
        label: Text('confirm'),
        icon: Icon(Icons.all_inbox),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Widget menu(BuildContext context, int favoriteCount, String picture,
      String name, int price) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              setState(() {
                orders.add({"picture": picture, "name": name, "price": price});
              });

              print(orders);
            },
            child: Container(
              width: 200,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: new EdgeInsets.all(0),
                      child: Container(
                          width: 200.0,
                          height: 150.0,
                          decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new AssetImage(picture))))),
                  Padding(
                      padding: new EdgeInsets.only(top: 10, left: 15),
                      child: Text(name,
                          style:
                              TextStyle(fontFamily: "Prompt", fontSize: 20))),
                  Row(
                    children: [
                      Padding(
                          padding: new EdgeInsets.only(top: 15, left: 15),
                          child: Text("${price} Bath",
                              style: TextStyle(
                                  fontFamily: "Prompt", fontSize: 15))),
                      Padding(
                        padding: new EdgeInsets.only(top: 10, left: 40),
                        child: FavoriteWidget(favoriteCount: favoriteCount),
                      )
                      // Padding(
                      //   padding: new EdgeInsets.only(top: 10, left: 15),
                      //   child: Text("Burger",
                      //       style:
                      //           TextStyle(fontFamily: "Prompt", fontSize: 20))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    Widget continueButton = FlatButton(
      child: Text("ตกลง", style: TextStyle(fontFamily: "Prompt", fontSize: 20)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("ยืนยันรายการ",
          style: TextStyle(fontFamily: "Prompt", fontSize: 25)),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  final int favoriteCount;
  FavoriteWidget({Key key, @required this.favoriteCount}) : super(key: key);
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState(favoriteCount);
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  int favoriteCount;
  _FavoriteWidgetState(this.favoriteCount);

  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        favoriteCount -= 1;
        _isFavorited = false;
      } else {
        favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            padding: EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: (_isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)),
            color: Colors.red[500],
            onPressed: _toggleFavorite,
          ),
        ),
        SizedBox(
          width: 18,
          child: Container(
            child: Text('$favoriteCount'),
          ),
        ),
      ],
    );
  }
}
