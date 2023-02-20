import 'package:demo1/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = "";

  @override
  void initState() {
    changeUidText(_auth.currentUser);
    _auth.userChanges().listen(changeUidText);
    super.initState();
  }

  void changeUidText(User user) {
    setState(() {
      if (user == null) {
        uid = "Signed out";
        return;
      }
      uid = user.uid;
      if (user.phoneNumber != null) {
        uid = user.phoneNumber;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _h = MediaQuery.of(context).size.height;
    final _w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0096eb),
        title: Text('Home'),
      ),
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(uid,
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 26)),
///////////////////////////////////////////////////////////////////////////////////////////////
              SizedBox(
                height: _h * 0.05,
              ),
///////////////////////////////////////////////////////////////////////////////////////////////
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("assets/OTP.png"))),
              ),
///////////////////////////////////////////////////////////////////////////////////////////////
              SizedBox(
                height: _h * 0.05,
              ),
///////////////////////////////////////////////////////////////////////////////////////////////
              Text(
                "OTP Demostrator",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w300,
                  fontSize: 25,
                ),
              ),
///////////////////////////////////////////////////////////////////////////////////////////////
              SizedBox(
                height: _h * 0.05,
              ),
///////////////////////////////////////////////////////////////////////////////////////////////
              Container(
                height: _h * 0.08,
                width: _w * 0.85,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 7),
                      )
                    ],
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [
                      Colors.blue.shade500,
                      Colors.blue.shade300,
                    ])),
                padding: const EdgeInsets.symmetric(horizontal: 80),
                // alignment: Alignment.center,
                child: SignInButtonBuilder(
                  icon: Icons.login_rounded,
                  text: "Sign Out",
                  onPressed: () async {
                    final User user = await _auth.currentUser;
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthExampleApp(),
                      ),
                    );
                    final String uid = user.uid;
                    Fluttertoast.showToast(
                      msg: "Logged Out",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  backgroundColor: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
