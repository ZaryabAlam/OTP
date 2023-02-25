import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home.dart';

//test

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AuthExampleApp());
}

/// The entry point of the application.
///
/// Returns a [MaterialApp].
class AuthExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SignInPage());
  }
}

/// Entrypoint example for various sign-in flows with Firebase.
class SignInPage extends StatefulWidget {
  /// The page title.
  final String title = 'OTP';

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
        // uid = "Signed out";
        return;
      }
      uid = user.uid;
      if (user.phoneNumber != null) {
        uid += " " + user.phoneNumber;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
        Fluttertoast.showToast(
          msg: "SignIn Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          padding: EdgeInsets.all(8),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Text(uid),
            _PhoneSignInSection(Scaffold.of(context)),
          ],
        );
      }),
    );
  }

  // Example code for sign out.
  void _signOut() async {
    await _auth.signOut();
  }
}

class _PhoneSignInSection extends StatefulWidget {
  _PhoneSignInSection(this._scaffold);

  final ScaffoldState _scaffold;

  @override
  State<StatefulWidget> createState() => _PhoneSignInSectionState();
}

class _PhoneSignInSectionState extends State<_PhoneSignInSection> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';
  String _verificationId;

  @override
  Widget build(BuildContext context) {
    final _h = MediaQuery.of(context).size.height;
    final _w = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: const Text('One Time Password',
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 26)),
              alignment: Alignment.center,
            ),
///////////////////////////////////////////////////////////////////////////////////////////////
            SizedBox(
              height: _h * 0.03,
            ),
///////////////////////////////////////////////////////////////////////////////////////////////
            Container(
              height: _h * 0.08,
              width: _w * 0.85,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 7),
                    )
                  ]),
              child: TextFormField(
                controller: _phoneNumberController,
                // keyboardType: TextInputType.number,
                // decoration: const InputDecoration(
                //     labelText: 'Phone number (+x xxx-xxx-xxxx)'),
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  hintText: 'Phone number (+x xxx-xxx-xxxx)',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Phone number (+x xxx-xxx-xxxx)';
                  }
                  return null;
                },
              ),
            ),
///////////////////////////////////////////////////////////////////////////////////////////////
            SizedBox(
              height: _h * 0.03,
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
                icon: Icons.message_rounded,
                text: "Send OTP",
                onPressed: () async {
                  _loginPhoneNumber();
                },
                backgroundColor: null,
              ),
            ),
///////////////////////////////////////////////////////////////////////////////////////////////
            SizedBox(
              height: _h * 0.06,
            ),
///////////////////////////////////////////////////////////////////////////////////////////////
            Container(
              height: _h * 0.08,
              width: _w * 0.85,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 7),
                    )
                  ]),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _smsController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  hintText: 'Verification code',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
///////////////////////////////////////////////////////////////////////////////////////////////
            SizedBox(
              height: _h * 0.03,
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
                icon: Icons.verified_user_rounded,
                onPressed: () async {
                  _signInWithPhoneNumber();
                },
                text: 'Sign In',
                backgroundColor: null,
              ),
            ),
            Visibility(
              visible: _message == null ? false : true,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _message,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ));
  }

  // Example code of how to verify phone number
  // void _verifyPhoneNumberAndLink() async {
  //   if (_auth.currentUser == null) {
  //     widget._scaffold.showSnackBar(const SnackBar(
  //       content: Text('No user signed in to link to'),
  //     ));
  //     return;
  //   }
  //   setState(() {
  //     _message = '';
  //   });

  //   PhoneVerificationCompleted verificationCompleted =
  //       (PhoneAuthCredential phoneAuthCredential) async {
  //     await _auth.currentUser.linkWithCredential(phoneAuthCredential);
  //     widget._scaffold.showSnackBar(SnackBar(
  //       content: Text(
  //           "Phone number automatically verified and linked: ${phoneAuthCredential}"),
  //     ));
  //   };

  //   PhoneVerificationFailed verificationFailed =
  //       (FirebaseAuthException authException) {
  //     setState(() {
  //       _message =
  //           'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
  //     });
  //   };

  //   PhoneCodeSent codeSent =
  //       (String verificationId, [int forceResendingToken]) async {
  //     widget._scaffold.showSnackBar(const SnackBar(
  //       content: Text('Please check your phone for the verification code.'),
  //     ));
  //     _verificationId = verificationId;
  //   };

  //   PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
  //       (String verificationId) {
  //     _verificationId = verificationId;
  //   };

  //   try {
  //     await _auth.verifyPhoneNumber(
  //         phoneNumber: _phoneNumberController.text,
  //         timeout: const Duration(seconds: 5),
  //         verificationCompleted: verificationCompleted,
  //         verificationFailed: verificationFailed,
  //         codeSent: codeSent,
  //         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  //   } catch (e) {
  //     widget._scaffold.showSnackBar(SnackBar(
  //       content: Text("Failed to Verify Phone Number: ${e}"),
  //     ));
  //   }
  // }

  void _loginPhoneNumber() async {
    setState(() {
      _message = '';
    });

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      widget._scaffold.showSnackBar(SnackBar(
        content: Text(
            "Phone number automatically verified and user signed in: ${phoneAuthCredential}"),
      ));
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      widget._scaffold.showSnackBar(const SnackBar(
        content: Text('Please check your phone for the verification code.'),
      ));
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      widget._scaffold.showSnackBar(SnackBar(
        content: Text("Failed to Verify Phone Number: ${e}"),
      ));
    }
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      _auth.signInWithCredential(credential);

      widget._scaffold.showSnackBar(SnackBar(
        content: Text("Successfully signed in UID: ${_auth.currentUser.uid}"),
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } catch (e) {
      // print(e);
      widget._scaffold.showSnackBar(SnackBar(
        content: Text("Failed to sign in"),
      ));
    }
  }
}
