import 'package:flutter/material.dart';

import 'package:loga_parameshwari/services/auth_services.dart';

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AuthService.signOut();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
