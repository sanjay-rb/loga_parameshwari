import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loga_parameshwari/screens/error_screen.dart';
import 'package:loga_parameshwari/screens/splash_screen.dart';
import 'package:loga_parameshwari/services/connectivity_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ConnectivityService(),
          child: MyApp(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      home: Consumer<ConnectivityService>(
        builder: (context, value, child) {
          if (value.isOnline) {
            return const SplashScreen();
          } else {
            return const ErrorScreen();
          }
        },
      ),
    );
  }
}
