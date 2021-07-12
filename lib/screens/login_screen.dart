import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';

import '../constant/constant.dart';
import '../services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String verificationId = "";
  TextEditingController _phoneNumberCtrl = TextEditingController();
  TextEditingController _smsOTPCtrl = TextEditingController();
  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: CachedNetworkImage(
              imageUrl: ImagesAndUrls.godImg,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black38,
          ),
          Positioned(
            top: Responsiveness.heightRatio(0.1),
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
            bottom: Responsiveness.heightRatio(0.2),
            left: Responsiveness.widthRatio(0.5) -
                Responsiveness.widthRatio(0.9) * 0.5,
            child: Card(
              child: Container(
                width: Responsiveness.widthRatio(0.9),
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Please enter your number"),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Phone number",
                          border: InputBorder.none,
                          prefix: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text("+91"),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        controller: _phoneNumberCtrl,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    this.codeSent
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Enter OTP",
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                controller: _smsOTPCtrl,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          )
                        : Container(),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (codeSent) {
                          AuthService.signInWithOTP(
                              _smsOTPCtrl.text.trim(), verificationId);
                        } else {
                          // var data = await AuthService.verifyPhone(
                          //     _phoneNumberCtrl.text.trim());
                          // print("DATA : $data ");
                          // setState(() {
                          //   this.verificationId = data[0];
                          //   this.codeSent = data[1];
                          // });
                          verifyPhone(_phoneNumberCtrl.text.trim());
                        }
                      },
                      child: codeSent ? Text('Login') : Text('Verify'),
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

  Future<void> verifyPhone(phoneNo) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    print("phonenumber : '+91$phoneNo'");
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNo',
      verificationCompleted: (PhoneAuthCredential credential) {
        AuthService.signIn(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("verificationFailed: (FirebaseAuthException $e)");
      },
      codeSent: (String verificationId, int resendToken) async {
        this.verificationId = verificationId;
        setState(() {
          this.codeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }
}
