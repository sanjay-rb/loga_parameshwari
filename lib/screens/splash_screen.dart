import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';

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
    setUp();
  }

  setUp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print("$packageName, $version, $buildNumber");
    var response = await http.get(Uri.parse(
        "https://app-status-sanjoke.herokuapp.com/getinfo?appid=$packageName"));
    var data = jsonDecode(response.body);
    if (data['version'] != version || buildNumber != data['build_number']) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Update available!"),
          content: Text("Please install new update out there."),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  NavigationAnimationService.fadePageRoute(
                    enterPage: AuthService.handleAuth(
                      onAuthorized: HomeScreen(),
                      onUnAuthorized: LoginScreen(),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.close),
              label: Text("Skip"),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // TODO :Update....
              },
              icon: Icon(Icons.done),
              label: Text("Update now"),
            ),
          ],
        ),
      );
    }
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
