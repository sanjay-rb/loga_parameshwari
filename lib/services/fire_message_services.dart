import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/pooja_model.dart';
import 'package:loga_parameshwari/screens/detail_pooja_screen/detail_pooja_screen.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class Messaging {
  String tag = "Messaging";
  static const String channelID = "com.sanjoke.loga_parameshwari";
  static const String channelTitle = "LPT Notification";

  static AndroidFlutterLocalNotificationsPlugin androidPlugin =
      FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  static final StreamController<String> selectNotificationStream =
      StreamController<String>.broadcast();

  static Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

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

  static void onSelectNotification(BuildContext context, String payload) {
    final String id = payload.split(':')[1];
    final String type = payload.split(':')[0];

    if (type == "deleted") {
      return;
    }

    DatabaseManager.getPoojaByID(id).then((PoojaModel pooja) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPooja(id: id, pooja: pooja),
        ),
      );
    });
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    final Map notification = message.data;
    final http.Response response = await http.get(
      Uri.parse(ImagesAndUrls.notificationBanner),
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
        visibility: NotificationVisibility.public,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      ),
      payload: notification['onClickData'].toString(),
    );
  }
}
