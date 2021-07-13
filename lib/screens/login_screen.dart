import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';

import '../services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String verId = "";
  TextEditingController _phoneNumberCtrl = TextEditingController();
  TextEditingController _smsOTPCtrl = TextEditingController();
  bool codeSent = false;
  bool isLoading = false;
  bool phoneNumberError = false;
  bool codeError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'images/god.webp',
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
                    SizedBox(
                      height: Responsiveness.height(10),
                    ),
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
                          errorText: phoneNumberError
                              ? "    Please enter correct phone number    "
                              : null,
                          errorBorder: InputBorder.none,
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
                                  errorText:
                                      codeError ? "   Invalid OTP   " : null,
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
                    SizedBox(
                      height: Responsiveness.height(10),
                    ),
                    isLoading ? LinearProgressIndicator() : Container(),
                    SizedBox(
                      height: Responsiveness.height(10),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          isLoading = true;
                          phoneNumberError = false;
                          codeError = false;
                        });

                        if (_phoneNumberCtrl.text.isEmpty ||
                            _phoneNumberCtrl.text.length < 10) {
                          setState(() {
                            phoneNumberError = true;
                            isLoading = false;
                          });
                        } else if (codeSent) {
                          if (_smsOTPCtrl.text.isEmpty ||
                              _smsOTPCtrl.text.length != 6) {
                            setState(() {
                              codeError = true;
                              isLoading = false;
                            });
                          }
                        }

                        if (!phoneNumberError && !codeError) {
                          if (codeSent) {
                            bool isverifyed = await AuthService.signInWithOTP(
                                _smsOTPCtrl.text.trim(), this.verId);
                            if (!isverifyed) {
                              setState(() {
                                codeError = true;
                                isLoading = false;
                              });
                            }
                          } else {
                            verifyPhone(_phoneNumberCtrl.text.trim());
                          }
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
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNo',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await AuthService.signIn(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("verificationFailed: (FirebaseAuthException $e)");
      },
      codeSent: (String verificationId, int resendToken) async {
        this.verId = verificationId;
        setState(() {
          this.codeSent = true;
          this.isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verId = verificationId;
      },
    );
  }
}
