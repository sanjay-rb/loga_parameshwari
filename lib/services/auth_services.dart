import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/user_model.dart';
import 'package:loga_parameshwari/screens/auth_error_screen.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

/// This services helps to perform authentication on the app with firebase auth....
///
/// This services required couple of packages....
///  - firebase_auth: ^2.0.0 (Null Safety)
///  - firebase_core: ^1.0.2 (Null Safety)
class AuthService {
  String tag = "AuthService";
  static FirebaseAuth _auth;

  ///
  static Future<void> init() async {
    _auth ??= FirebaseAuth.instance;
  }

  static Future<void> updateUserDB(User authUser) async {
    final QuerySnapshot user = await DatabaseManager.getUserInfoById(
      authUser.phoneNumber,
    );
    if (user.docs.length == 1) {
      final UserModel userModel = UserModel.fromJson(user.docs[0]);
      userModel.isonline = true;
      await DatabaseManager.addUser(userModel);
    } else {
      await DatabaseManager.addUser(
        UserModel(
          id: authUser.phoneNumber,
          uid: authUser.uid,
          name: authUser.displayName ?? "New User",
          isverified: false,
          isonline: true,
        ),
      );
    }
  }

  /// Check for the Auth State and navigate to screens....
  static Widget handleAuth({Widget onAuthorized, Widget onUnAuthorized}) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          AuthService.updateUserDB(snapshot.data);
          return onAuthorized;
        } else {
          return onUnAuthorized;
        }
      },
    );
  }

  /// SignOut from the current user....
  static Future<void> signOut() async {
    await DatabaseManager.getUserInfoById(
      FirebaseAuth.instance.currentUser.phoneNumber,
    ).then((value) {
      if (value.docs.length == 1) {
        final UserModel user = UserModel.fromJson(value.docs.first);
        user.isonline = false;
        DatabaseManager.addUser(user);
      }
    });
    _auth.signOut();
  }

  /// SignIn with the help of AuthCredential....
  static Future<bool> signIn(AuthCredential authCreds) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(authCreds);
      AuthService.updateUserDB(userCredential.user);
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
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNo',
      verificationCompleted: (PhoneAuthCredential credential) {
        signIn(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        logger.e("ERROR ::: verificationFailed: (FirebaseAuthException $e)");
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

class IsAuthorized extends StatelessWidget {
  final Widget child;
  const IsAuthorized({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          AuthService.updateUserDB(snapshot.data);
          return child;
        } else {
          return const AuthErrorScreen();
        }
      },
    );
  }
}
