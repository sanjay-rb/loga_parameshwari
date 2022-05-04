// ignore_for_file: avoid_classes_with_only_static_members, avoid_dynamic_calls, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppUpdateService {
  static PackageInfo packageInfo;
  static Future<void> init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  static Future<void> checkUpdate(BuildContext context) async {
    final response = await http.get(
      Uri.parse(
        "https://app-status-sanjoke.herokuapp.com/getinfo?appid=${packageInfo.packageName}",
      ),
    );
    final data = jsonDecode(response.body);
    if (data['version'] != packageInfo.version ||
        data['build_number'] != packageInfo.buildNumber) {
      final bool result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              SizedBox(
                width: Responsiveness.width(50),
                height: Responsiveness.height(50),
                child: Image.asset("images/icon.png"),
              ),
              const Text("Update available!"),
            ],
          ),
          content: const Text("Please update the app for new features."),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context, false);
              },
              icon: const Icon(Icons.close),
              label: const Text("Skip"),
            ),
            TextButton.icon(
              onPressed: () async {
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.done),
              label: const Text("Update now"),
            ),
          ],
        ),
      );
      if (result) {
        if (await canLaunch(ImagesAndUrls.googlePlayLink)) {
          await launch(ImagesAndUrls.googlePlayLink);
          SystemNavigator.pop();
        }
      }
    }
  }
}
