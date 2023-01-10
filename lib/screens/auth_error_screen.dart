import 'package:flutter/material.dart';
import 'package:loga_parameshwari/screens/login_screen.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';

class AuthErrorScreen extends StatelessWidget {
  const AuthErrorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Responsiveness.init(MediaQuery.of(context).size); // 5....
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
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
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: Responsiveness.heightRatio(0.5),
                  ),
                  const Text(
                    "Loga Parameshwari Thunai",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.amber,
                    ),
                  ),
                  Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "You are not logged in, please login by clicking below button",
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text('Login'),
                          ),
                        ],
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
