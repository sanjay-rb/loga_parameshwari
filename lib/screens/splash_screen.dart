import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loga_parameshwari/services/admob_services.dart';

import './home_screen/home_screen.dart';
import './login_screen.dart';
import '../constant/constant.dart';
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
  double _totalPreload = 7;
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
    await Messaging.init(); // 1....
    _loadProgress(1);
    await DatabaseManager.init(); // 2....
    _loadProgress(2);
    await AuthService.init(); // 3....
    _loadProgress(3);
    Responsiveness.init(MediaQuery.of(context).size); // 4....
    _loadProgress(4);
    await InAppUpdateService.init(); // 5....
    _loadProgress(5);
    await InAppUpdateService.checkUpdate(context); // 6....
    _loadProgress(6);
    await AdmobServices.init(); // 7...
    _loadProgress(7);

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
                CachedNetworkImage(
                  imageUrl: ImagesAndUrls.godImg,
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
