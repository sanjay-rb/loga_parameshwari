import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareApp extends StatelessWidget {
  const ShareApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
      child: TextButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () {
          Share.share(
              "Install this app for get live information about the Loga Parameshwari Temple Ramassery https://play.google.com/store/apps/details?id=com.sanjoke.loga_parameshwari");
        },
        icon: Icon(Icons.share, color: Colors.white),
        label: Text(
          "Share",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
