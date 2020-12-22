import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'homePage.dart';

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
          children: <Widget>[
             Padding(
                padding: new EdgeInsets.only(bottom: 20),
                child: Text("Owl Food",style: TextStyle(
                                fontFamily: "Prompt",
                                fontSize: 30,
                                fontWeight: FontWeight.bold))),

             Padding(
                padding: new EdgeInsets.only(bottom: 150.0),
                child: Image(
                  image: AssetImage('assets/images/owlz-logo.png'),
                  width: 250,
                  height: 200,
                )),
                
            SignInButton(
              Buttons.Facebook,
              text: "Login with facebook",
              // mini: true,
              onPressed: () {
                loginWithFacebook(context);
              },
            )
          ],
        ),
      ),
    );
  }

  // Widget buildButtonFacebook(BuildContext context) {
  //   return InkWell(
  //       child: Container(
  //           constraints: BoxConstraints.expand(height: 50),
  //           child: Text("Login with Facebook ",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontSize: 18, color: Colors.white)),
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(16),
  //               color: Colors.blue[400]),
  //           margin: EdgeInsets.only(top: 12),
  //           padding: EdgeInsets.all(12)),
  //       onTap: () => loginWithFacebook(context));
  // }

  Future loginWithFacebook(BuildContext context) async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult result = await facebookLogin
        .logInWithReadPermissions(['email', "public_profile"]);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        String token = result.accessToken.token;

        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(100).height(100),email&access_token=${token}');
        final profile = JsonDecoder().convert(graphResponse.body);
        await _auth.signInWithCredential(
            FacebookAuthProvider.getCredential(accessToken: token));
        setState(() => _isLoggedIn = true);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(profile: profile)));
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }

    // checkAuth(context, profile); // after success, navigate to home.
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
