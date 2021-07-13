import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// This services helps to perform authentication on the app with firebase auth....
///
/// This services requried couple of packages....
///  - firebase_auth: ^2.0.0 (Null Safety)
///  - firebase_core: ^1.0.2 (Null Safety)
class AuthService {
  static FirebaseAuth _auth;

  ///
  static init() {
    if (_auth == null) {
      _auth = FirebaseAuth.instance;
    }
  }

  /// Check for the Auth State and navigate to screens....
  static handleAuth({Widget onAuthorized, Widget onUnAuthorized}) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return onAuthorized;
        } else {
          return onUnAuthorized;
        }
      },
    );
  }

  /// SignOut from the current user....
  static signOut() {
    _auth.signOut();
  }

  /// SignIn with the help of AuthCredential....
  static signIn(AuthCredential authCreds) async {
    await _auth.signInWithCredential(authCreds);
  }

  /// SignIn with the help of OTP....
  static signInWithOTP(smsCode, verId) {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }

  // Get current user phonenumber....
  static getUserNumber() {
    return _auth.currentUser.phoneNumber;
  }

  static Future<List> verifyPhone(phoneNo) async {
    String verificationId;
    bool codeSent = false;
    print("phonenumber : '+91$phoneNo'");
    print("AUTH : $_auth");
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNo',
      verificationCompleted: (PhoneAuthCredential credential) {
        signIn(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("verificationFailed: (FirebaseAuthException $e)");
      },
      codeSent: (String verificationId, int resendToken) async {
        verificationId = verificationId;
        codeSent = true;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
      },
    );
    return [verificationId, codeSent];
  }

  /**
   Future<void> verifyPhone(phoneNo) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    print("phonenumber : '+91$phoneNo'");
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNo',
      verificationCompleted: (PhoneAuthCredential credential) {
        AuthService().signIn(credential);
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
   */
}
