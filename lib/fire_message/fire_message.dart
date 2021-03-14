import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:meta/meta.dart';

class Messaging {
  static Future<http.Response> send({
    @required String title,
    @required String body,
  }) =>
      http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: json.encode({
          "to": "/topics/all",
          "notification": {
            "title": "$title",
            "body": "$body",
          }
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAZCPfm4I:APA91bHfQkiVDflbWTHDlf6tZPASoa41uKXQkxiOjRSpCezcNdiiiMLT1tIvNOGBbUvqckjSq8mE2pMHURP8Qeo8Nm5QkYwtrfe0pW7hbhJ9dwcWzLuTTcLVw9b5K1SIqHUEusREdoN4',
        },
      );
}
