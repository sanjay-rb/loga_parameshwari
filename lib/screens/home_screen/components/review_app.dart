import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/constant.dart';

class ReviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
      child: TextButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () async {
          if (await canLaunch(ImagesAndUrls.googlePlayLink)) {
            launch(ImagesAndUrls.googlePlayLink);
          }
        },
        icon: Icon(Icons.star, color: Colors.white),
        label: Text(
          "Review",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
