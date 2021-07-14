import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../constant/constant.dart';

/// This service helps to connect and trigger the firebase messaging....
///
/// You can set canNotify as true before triggering send() func....
class Messaging {
  static const bool CAN_NOTIFY = true;

  /// Please call init() function before main or splash screen....
  static init() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance.subscribeToTopic("all");
  }

  /// This send() function create http request to the firebase messageing and trigger the message....
  /// Pleas provide the title and body of the notifcation...
  static Future<http.Response> send({
    @required String title,
    @required String body,
  }) {
    return CAN_NOTIFY
        ? http.post(
            Uri.parse("https://fcm.googleapis.com/fcm/send"),
            body: json.encode({
              "to": "/topics/all",
              "notification": {
                "title": "$title",
                "body": "$body",
                "imageUrl": "${ImagesAndUrls.logoImg}",
                "icon": "${ImagesAndUrls.logoImg}",
                "sound": "default"
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
            http.Response("Message not send status is $CAN_NOTIFY", 200),
          );
  }
}
