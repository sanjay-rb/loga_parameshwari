import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:loga_parameshwari/constant/constant.dart';

class Messaging {
  static bool canNotify = false;
  static Future<http.Response> send({
    @required String title,
    @required String body,
  }) {
    return canNotify
        ? http.post(
            Uri.parse("https://fcm.googleapis.com/fcm/send"),
            body: json.encode({
              "to": "/topics/all",
              "notification": {
                "title": "$title",
                "body": "$body",
                "imageUrl": "${ImagesAndUrls.logoImg}"
              }
            }),
            headers: <String, String>{
              "authorization":
                  "key=AAAAZCPfm4I:APA91bHfQkiVDflbWTHDlf6tZPASoa41uKXQkxiOjRSpCezcNdiiiMLT1tIvNOGBbUvqckjSq8mE2pMHURP8Qeo8Nm5QkYwtrfe0pW7hbhJ9dwcWzLuTTcLVw9b5K1SIqHUEusREdoN4",
              "content-type": "application/json",
              "cache-control": "no-cache",
              "postman-token": "45b5e103-f15a-1847-c77d-d70f9ce2f475",
            },
          )
        : Future.value(
            http.Response("Message not send status is $canNotify", 200));
  }
}
