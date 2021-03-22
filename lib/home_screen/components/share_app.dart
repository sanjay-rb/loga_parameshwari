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
              "This is Sanjay, Ping for for Test https://play.google.com/store/apps/developer?id=Sanjay+R+B");
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
