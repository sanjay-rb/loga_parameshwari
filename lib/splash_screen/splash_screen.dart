import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/home_screen/home_screen.dart';
import 'package:loga_parameshwari/login_screen/login_screen.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/navigation_animation_services.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';

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
    ResponsiveService.screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: ResponsiveService.screenSize.width,
            height: ResponsiveService.screenSize.height,
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
            bottom: ResponsiveService.height(150),
            left: ResponsiveService.screenSize.width * 0.5 -
                (ResponsiveService.widthRatio(0.5) * 0.5),
            child: SizedBox(
              width: ResponsiveService.widthRatio(0.5),
              child: LinearProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
