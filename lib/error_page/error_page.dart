import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';

class ErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loga Parameshwari Temple',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ErrorPage(),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Oops it's look like your not connected to internet 😕. Please check your internet connection 👍.",
          style: TextDesign.titleText,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
