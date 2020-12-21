import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LandingPage extends StatefulWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;

  void initState() {
    super.initState();
    // checkAuth(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[buildButtonFacebook(context)],
        ),
      ),
    );
  }

  Widget buildButtonFacebook(BuildContext context) {
    return InkWell(
        child: Container(
            constraints: BoxConstraints.expand(height: 50),
            child: Text("Login with Facebook ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue[400]),
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(12)),
        onTap: () => loginWithFacebook(context));
  }

  Future loginWithFacebook(BuildContext context) async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult result = await facebookLogin
        .logInWithReadPermissions(['email', "public_profile"]);

    String token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
    final profile = JsonDecoder().convert(graphResponse.body);
    print(profile);

    await _auth.signInWithCredential(
        FacebookAuthProvider.getCredential(accessToken: token));
    setState(() => {_isLoggedIn = false});

    checkAuth(context, profile); // after success, navigate to home.
  }

  Future checkAuth(BuildContext context, var profile) async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      print("Already singed-in with");
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => MyHomePage(user)));
    }
  }
}
