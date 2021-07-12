import 'package:flutter/material.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/constant.dart';

class ErrorApp extends StatelessWidget {
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
      home: ErrorPage(),
    );
  }
}

class ErrorPage extends StatefulWidget {
  const ErrorPage({
    Key key,
  }) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Oops, it looks like your not connected to the internet 😕. \nPlease check your internet connection 👍.",
                style: TextDesign.titleText,
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () {
                  FlutterRestart.restartApp();
                },
                child: Text("Reload"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
