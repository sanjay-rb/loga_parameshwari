import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void showOTPDialog(String verificationId, int forceResendingToken) {
    TextEditingController _otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Enter the "One Time Password" which is sent to the phone number.',
                  textAlign: TextAlign.center,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'OTP',
                ),
                controller: _otpController,
              ),
              Builder(
                builder: (context) => TextButton(
                  onPressed: () async {
                    final code = _otpController.text.trim();
                    try {
                      AuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: verificationId, smsCode: code);
                      if (credential != null) {
                        print("credential $credential");
                      } else {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Error in User Login"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Try again!'),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      Navigator.pop(context);
                      print(e);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Error in User Login"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Try again!'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text("Verify"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "images/god.webp",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black38,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Loga Parameshwari Thunai",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            left: (MediaQuery.of(context).size.width * 0.5) -
                (MediaQuery.of(context).size.width * 0.9 * 0.5),
            child: Card(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Please enter your number"),
                    TextField(
                      keyboardType: TextInputType.phone,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        // TODO OTP auth....
                        _auth.verifyPhoneNumber(
                          phoneNumber: "+919442212906",
                          timeout: Duration(seconds: 60),
                          verificationCompleted: (phoneAuthCredential) async {
                            UserCredential userCredential = await _auth
                                .signInWithCredential(phoneAuthCredential);
                            if (userCredential.user != null) {
                              print(userCredential.user);
                            }
                          },
                          verificationFailed: (error) {
                            print(error);
                          },
                          codeSent: showOTPDialog,
                          codeAutoRetrievalTimeout: null,
                        );
                      },
                      child: Text("Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
