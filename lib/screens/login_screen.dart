import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/connectivity_service.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String verId = "";
  final TextEditingController _phoneNumberCtrl = TextEditingController();
  final TextEditingController _smsOTPCtrl = TextEditingController();
  bool codeSent = false;
  bool isLoading = false;
  bool phoneNumberError = false;
  bool codeError = false;
  @override
  Widget build(BuildContext context) {
    return IsConnected(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Text(
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
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: Responsiveness.height(10),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Phone number",
                            border: InputBorder.none,
                            prefix: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Text("+91"),
                            ),
                            errorText: phoneNumberError
                                ? "    Please enter correct phone number    "
                                : null,
                            errorBorder: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          controller: _phoneNumberCtrl,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      if (codeSent)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DecoratedBox(
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
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              controller: _smsOTPCtrl,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        )
                      else
                        Container(),
                      SizedBox(
                        height: Responsiveness.height(10),
                      ),
                      if (isLoading)
                        const LinearProgressIndicator()
                      else
                        Container(),
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
                              final bool isVerified =
                                  await AuthService.signInWithOTP(
                                _smsOTPCtrl.text.trim(),
                                verId,
                              );
                              if (!isVerified) {
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
                        child: codeSent
                            ? const Text('Login')
                            : const Text('Verify'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyPhone(String phoneNo) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNo',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await AuthService.signIn(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        logger.e("ERROR ::: verificationFailed: (FirebaseAuthException $e)");
      },
      codeSent: (String verificationId, int resendToken) async {
        verId = verificationId;
        setState(() {
          codeSent = true;
          isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verId = verificationId;
      },
    );
  }
}
