// ignore_for_file: use_build_context_synchronously

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/special_dates_model.dart';
import 'package:loga_parameshwari/screens/home_screen/home_screen.dart';
import 'package:loga_parameshwari/screens/login_screen.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/connectivity_service.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:loga_parameshwari/services/fire_message_services.dart';
import 'package:loga_parameshwari/services/navigation_animation_services.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  final double _totalPreload = 10;

  String _progressText = "Welcome to Loga Parameshwari Temple App....";
  @override
  void initState() {
    setUp();
    super.initState();
  }

  void _loadProgress(double id, String text) {
    setState(() {
      _progress = id / _totalPreload;
      _progressText = text;
    });
  }

  Future<void> setUp() async {
    _loadProgress(1, "Requesting Permissions....");
    await requestPermission();
    _loadProgress(2, "Initializing Database....");
    await Firebase.initializeApp();
    _loadProgress(3, "Initializing Messages....");
    await Messaging.init();
    _loadProgress(4, "Initializing Local Database....");
    await DatabaseManager.init();
    _loadProgress(5, "Initializing Auth....");
    await AuthService.init();
    _loadProgress(6, "Initializing Responsiveness....");
    Responsiveness.init(MediaQuery.of(context).size);
    _loadProgress(7, "Initializing In App Update....");
    await InAppUpdate.init();
    _loadProgress(8, "Checking for new versions....");
    await InAppUpdate.checkUpdate(context, ImagesAndUrls.googlePlayLink);
    _loadProgress(9, "Updating Special Poojas....");
    await SpecialDatesModel().updatePoojas();
    _loadProgress(10, "App ready to launch....");

    if (_progress.toInt() == 1) {
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

  Future<void> requestPermission() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final List<Permission> permissions = [
      Permission.storage,
      Permission.notification
    ];
    final Map<Permission, PermissionStatus> statuses = {};
    for (final Permission perm in permissions) {
      if (perm == Permission.storage && android.version.sdkInt < 33) {
        final PermissionStatus result = await perm.request();
        statuses[perm] = result;
      } else {
        statuses[perm] = PermissionStatus.granted;
      }
    }

    for (final Permission permission in permissions) {
      while (statuses[permission].isDenied ||
          statuses[permission].isPermanentlyDenied) {
        if (statuses[permission].isDenied) {
          statuses[permission] = await permission.request();
        }
        if (statuses[permission].isPermanentlyDenied) {
          final bool isTrue = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Required Permission : $permission"),
              content: const Text(
                "As you have not given the required permission to access storage, you are unable to upload images to any pooja.",
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                  child: const Text("Continue"),
                )
              ],
            ),
          );
          if (isTrue) {
            // await openAppSettings();
            // statuses[permission] = await permission.status;
            statuses[permission] = PermissionStatus.restricted;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IsConnected(
      child: Scaffold(
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
                  const ColoredBox(
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
                    LinearProgressIndicator(value: _progress),
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
      ),
    );
  }
}
