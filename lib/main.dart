import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

import './screens/error_screen.dart';
import './screens/splash_screen.dart';
import './services/auth_services.dart';
import './services/fire_message_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  if (await Connectivity().checkConnection()) {
    await Firebase.initializeApp();
    await Messaging.init();
    await DatabaseManager.init();
    await AuthService.init();
    runApp(MyApp());
  } else {
    runApp(ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loga Parameshwari Temple',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      home: SplashScreen(),
    );
  }
}
