import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class Messaging {
  String tag = "Messaging";
  static const bool canNotify = false;
  static const String channelID = "com.sanjoke.loga_parameshwari";
  static const String channelTitle = "LPT Notification";

  static AndroidFlutterLocalNotificationsPlugin androidPlugin =
      FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  static final StreamController<String> selectNotificationStream =
      StreamController<String>.broadcast();

  static Future<void> init() async {
    await FirebaseMessaging.instance.subscribeToTopic(channelID);

    final bool areNotificationsEnabled =
        await androidPlugin.areNotificationsEnabled();
    if (areNotificationsEnabled != null) {
      if (!areNotificationsEnabled) {
        androidPlugin.requestPermission();
      }
    }
    androidPlugin.deleteNotificationChannel(channelID);
    androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        channelID,
        channelTitle,
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('notification_tone'),
      ),
    );

    Messaging.androidPlugin.initialize(
      const AndroidInitializationSettings("@mipmap/ic_launcher"),
      onDidReceiveNotificationResponse: (notificationResponse) {
        if (notificationResponse.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          selectNotificationStream.add(notificationResponse.payload);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {
    if (notificationResponse.notificationResponseType ==
        NotificationResponseType.selectedNotification) {
      Messaging.selectNotificationStream.add(notificationResponse.payload);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> backgroundAndTerminatedMessageHandler(
    RemoteMessage message,
  ) async {
    // ! For Message handler
    Messaging.showLocalNotification(message);
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    final Map notification = message.data;
    final http.Response response = await http.get(
      Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Fbackground.png?alt=media&token=d1316d19-895c-4e0a-a141-1a1fbf4f1ab7",
      ),
    );
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(
        base64Encode(
          response.bodyBytes,
        ),
      ),
      largeIcon: ByteArrayAndroidBitmap.fromBase64String(
        base64Encode(
          response.bodyBytes,
        ),
      ),
    );
    androidPlugin.show(
      DateTime.now().microsecond,
      notification['title'].toString(),
      notification['subtitle'].toString(),
      notificationDetails: AndroidNotificationDetails(
        channelID,
        channelTitle,
        priority: Priority.max,
        styleInformation: bigPictureStyleInformation,
        category: AndroidNotificationCategory.message,
        visibility: NotificationVisibility.private,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      ),
      payload: notification['id'].toString(),
    );
  }
}
