// ignore_for_file: use_build_context_synchronously

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:loga_parameshwari/constant/constant.dart';
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
  final double _totalPreload = 8;

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
    await requestPermission();
    await Firebase.initializeApp(); // 1....
    _loadProgress(1, "Loading....");
    await Messaging.init(); // 2....
    _loadProgress(2, "Messaging Connected....");
    await DatabaseManager.init(); // 3....
    _loadProgress(3, "Data Fetched....");
    await AuthService.init(); // 4....
    _loadProgress(4, "Authorization Checked....");
    Responsiveness.init(MediaQuery.of(context).size); // 5....
    _loadProgress(5, "Loading....");
    await InAppUpdate.init(); // 6....
    _loadProgress(6, "App Update Started....");
    await InAppUpdate.checkUpdate(
      context,
      ImagesAndUrls.googlePlayLink,
    ); // 7....
    _loadProgress(7, "App Update Checked....");
    _loadProgress(8, "Ads Loaded....");

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
