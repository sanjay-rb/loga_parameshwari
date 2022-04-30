import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/screens/profile_screen.dart';
import 'package:loga_parameshwari/services/navigation_animation_services.dart';

class LeftBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
      child: TextButton.icon(
        key: GKey.profileBtnKey,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () async {
          Navigator.of(context).push(
            NavigationAnimationService.leftToRightPageRoute(
              exitPage: this,
              enterPage: const ProfileScreen(),
            ),
          );
        },
        icon: const Icon(Icons.account_box, color: Colors.white),
        label: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
