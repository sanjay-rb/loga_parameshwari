import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/services/responsive_services.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class InAppUpdateService {
  static PackageInfo packageInfo;
  static init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  static checkUpdate(BuildContext context) async {
    var response = await http.get(
      Uri.parse(
        "https://app-status-sanjoke.herokuapp.com/getinfo?appid=${packageInfo.packageName}",
      ),
    );
    var data = jsonDecode(response.body);
    if (data['version'] != packageInfo.version ||
        data['build_number'] != packageInfo.buildNumber) {
      bool result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              SizedBox(
                width: Responsiveness.width(50),
                height: Responsiveness.height(50),
                child: CachedNetworkImage(imageUrl: ImagesAndUrls.logoImg),
              ),
              Text("Update available!"),
            ],
          ),
          content: Text("Please update the app for new features."),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context, false);
              },
              icon: Icon(Icons.close),
              label: Text("Skip"),
            ),
            TextButton.icon(
              onPressed: () async {
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.done),
              label: Text("Update now"),
            ),
          ],
        ),
      );
      if (result) {
        if (await canLaunch(ImagesAndUrls.googlePlayLink)) {
          await launch(ImagesAndUrls.googlePlayLink);
        }
      }
    }
  }
}
