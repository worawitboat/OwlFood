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
            Padding(
                padding: new EdgeInsets.only(top: 50.0),
                child: _widgetOptions.elementAt(_selectedIndex)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Favorite',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
