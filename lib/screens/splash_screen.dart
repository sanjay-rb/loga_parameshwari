import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './home_screen/home_screen.dart';
import './login_screen.dart';
import '../constant/constant.dart';
import '../services/auth_services.dart';
import '../services/navigation_animation_services.dart';
import '../services/responsive_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        NavigationAnimationService().fadePageRoute(
          enterPage: AuthService().handleAuth(
            onAuthorized: HomeScreen(),
            onUnAuthorized: LoginScreen(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsiveness.init(MediaQuery.of(context).size);
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
              child: LinearProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
