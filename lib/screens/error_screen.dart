import 'package:flutter/material.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Responsiveness.init(MediaQuery.of(context).size); // 5....
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'images/god.webp',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black38,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: Responsiveness.heightRatio(0.5),
                  ),
                  Text(
                    "Loga Parameshwari Thunai",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.amber,
                    ),
                  ),
                  Card(
                    child: Container(
                      width: Responsiveness.widthRatio(0.8),
                      height: Responsiveness.heightRatio(0.3),
                      child: Center(
                        child: Text(
                          "Please check your internet connection",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
