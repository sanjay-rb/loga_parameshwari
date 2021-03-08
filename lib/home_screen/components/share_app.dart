import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareApp extends StatelessWidget {
  const ShareApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Share.share(
            "This is Sanjay, Ping for for Test https://play.google.com/store/apps/developer?id=Sanjay+R+B");
      },
      icon: Icon(Icons.share),
      label: Text("Share App"),
    );
  }
}
