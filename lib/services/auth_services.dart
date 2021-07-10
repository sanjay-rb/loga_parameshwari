import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// This services helps to perform authentication on the app with firebase auth....
///
/// This services requried couple of packages....
///  - firebase_auth: ^2.0.0 (Null Safety)
///  - firebase_core: ^1.0.2 (Null Safety)
class AuthService {
  /// Check for the Auth State and navigate to screens....
  handleAuth({Widget onAuthorized, Widget onUnAuthorized}) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return onAuthorized;
          } else {
            return onUnAuthorized;
          }
        });
  }

  /// SignOut from the current user....
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  /// SignIn with the help of AuthCredential....
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  /// SignIn with the help of OTP....
  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }

  // Get current user phonenumber....
  getUserNumber() {
    return FirebaseAuth.instance.currentUser.phoneNumber;
  }
}
