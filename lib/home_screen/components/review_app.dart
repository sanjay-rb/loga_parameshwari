import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

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
          final InAppReview inAppReview = InAppReview.instance;

          if (await inAppReview.isAvailable()) {
            inAppReview.requestReview();
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
