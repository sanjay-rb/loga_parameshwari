import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/model/user.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

// ignore: avoid_classes_with_only_static_members
/// This services helps to perform authentication on the app with firebase auth....
///
/// This services required couple of packages....
///  - firebase_auth: ^2.0.0 (Null Safety)
///  - firebase_core: ^1.0.2 (Null Safety)
class AuthService {
  static FirebaseAuth _auth;

  ///
  static Future<void> init() async {
    _auth ??= FirebaseAuth.instance;
  }

  /// Check for the Auth State and navigate to screens....
  static Widget handleAuth({Widget onAuthorized, Widget onUnAuthorized}) {
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
  static void signOut() {
    _auth.signOut();
  }

  /// SignIn with the help of AuthCredential....
  static Future<bool> signIn(AuthCredential authCreds) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(authCreds);
      if (userCredential.additionalUserInfo.isNewUser) {
        await DatabaseManager.addUser(
          UserModel(
            id: userCredential.user.phoneNumber,
            uid: userCredential.user.uid,
            name: userCredential.user.displayName ?? "New User",
          ),
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// SignIn with the help of OTP....
  static Future<bool> signInWithOTP(String smsCode, String verId) async {
    final AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    return signIn(authCreds);
  }

  // Get current user phone number....
  static String getUserNumber() {
    return _auth.currentUser.phoneNumber;
  }

  static Future<List> verifyPhone(String phoneNo) async {
    String verificationId;
    bool codeSent = false;
    if (kDebugMode) {
      print("phonenumber : '+91$phoneNo'");
      print("AUTH : $_auth");
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNo',
      verificationCompleted: (PhoneAuthCredential credential) {
        signIn(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (kDebugMode) {
          print("verificationFailed: (FirebaseAuthException $e)");
        }
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
}
