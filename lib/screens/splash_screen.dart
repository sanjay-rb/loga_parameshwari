// ignore_for_file: use_build_context_synchronously

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/screens/home_screen/home_screen.dart';
import 'package:loga_parameshwari/screens/login_screen.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:loga_parameshwari/services/fire_message_services.dart';
import 'package:loga_parameshwari/services/in_app_update_services.dart';
import 'package:loga_parameshwari/services/navigation_animation_services.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progess = 0.0;
  final double _totalPreload = 8;

  String _progressText = "Welcome to Loga Parameshwari Temple App....";
  @override
  void initState() {
    setUp();
    super.initState();
  }

  void _loadProgress(double id, String text) {
    setState(() {
      _progess = id / _totalPreload;
      _progressText = text;
    });
  }

  Future<void> setUp() async {
    await Firebase.initializeApp(); // 1....
    _loadProgress(1, "Loading....");
    await Messaging.init(); // 2....
    _loadProgress(2, "Messageing Connected....");
    await DatabaseManager.init(); // 3....
    _loadProgress(3, "Data Fetched....");
    await AuthService.init(); // 4....
    _loadProgress(4, "Authorization Checked....");
    Responsiveness.init(MediaQuery.of(context).size); // 5....
    _loadProgress(5, "Loading....");
    await InAppUpdateService.init(); // 6....
    _loadProgress(6, "App Update Started....");
    await InAppUpdateService.checkUpdate(context); // 7....
    _loadProgress(7, "App Update Checked....");
    _loadProgress(8, "Ads Loaded....");

    if (_progess.toInt() == 1) {
      Navigator.pushReplacement(
        context,
        NavigationAnimationService.fadePageRoute(
          enterPage: AuthService.handleAuth(
            onAuthorized: HomeScreen(),
            onUnAuthorized: const LoginScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: Responsiveness.screenSize.width,
            height: Responsiveness.screenSize.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'images/god.webp',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: Responsiveness.height(150),
            left: Responsiveness.screenSize.width * 0.5 -
                (Responsiveness.widthRatio(0.5) * 0.5),
            child: SizedBox(
              width: Responsiveness.widthRatio(0.5),
              child: Column(
                children: [
                  LinearProgressIndicator(value: _progess),
                  Text(
                    _progressText,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
