import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/services/admob_services.dart';

import './home_screen/home_screen.dart';
import './login_screen.dart';
import '../services/auth_services.dart';
import '../services/navigation_animation_services.dart';
import '../services/responsive_services.dart';
import '../services/database_manager.dart';
import '../services/fire_message_services.dart';
import '../services/in_app_update_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progess = 0.0;
  double _totalPreload = 8;
  @override
  void initState() {
    setUp();
    super.initState();
  }

  _loadProgress(double id) {
    setState(() {
      _progess = (id / _totalPreload);
    });
  }

  setUp() async {
    await Firebase.initializeApp(); // 1....
    _loadProgress(1);
    await Messaging.init(); // 2....
    _loadProgress(2);
    await DatabaseManager.init(); // 3....
    _loadProgress(3);
    await AuthService.init(); // 4....
    _loadProgress(4);
    Responsiveness.init(MediaQuery.of(context).size); // 5....
    _loadProgress(5);
    await InAppUpdateService.init(); // 6....
    _loadProgress(6);
    await InAppUpdateService.checkUpdate(context); // 7....
    _loadProgress(7);
    await AdmobServices.init(); // 8...
    _loadProgress(8);

    if (_progess.toInt() == 1) {
      Navigator.pushReplacement(
        context,
        NavigationAnimationService.fadePageRoute(
          enterPage: AuthService.handleAuth(
            onAuthorized: HomeScreen(),
            onUnAuthorized: LoginScreen(),
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
          Container(
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
              child: LinearProgressIndicator(value: _progess),
            ),
          ),
        ],
      ),
    );
  }
}
