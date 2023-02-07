import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:loga_parameshwari/model/pooja.dart';

class TextDesign {
  const TextDesign();
  static const headText = TextStyle(
    fontSize: 25,
    color: Colors.black,
    overflow: TextOverflow.fade,
  );

  static const titleText = TextStyle(
    fontSize: 20,
    color: Colors.black,
    overflow: TextOverflow.fade,
  );

  static const subTitleText = TextStyle(
    fontSize: 15,
    color: Colors.black,
    overflow: TextOverflow.fade,
  );

  static String getMessageText(Pooja pooja, String link) =>
      "Hi, your invited to *${pooja.name.trim()}*\non *${DateFormat("dd MMMM yyyy (hh:mm aaa)").format(pooja.on.toDate())}*\nby *${pooja.by.trim()}*.\n\nWe request your gracious presence on this auspicious occasion.\n$link\nClick the link for further information.";
}

class CardContainer {
  static const borderRadius = BorderRadius.all(
    Radius.circular(20),
  );
}

class ImagesAndUrls {
  const ImagesAndUrls();
  static const mapImg =
      "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Flocation.png?alt=media&token=a1527275-6659-47a7-b7a5-a67fc9c71ec3";
  static const mapUrl = "https://goo.gl/maps/dTXWo6dTdQ8Bgsi28";
  static const historyImg =
      "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Fhistory.png?alt=media&token=231b1981-7c7e-4fa2-a21f-108660b74fc3";
  static const logoImg =
      "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Flogo.png?alt=media&token=830a8425-ccea-4d0e-9b2d-bd3fbfd4e385";
  static const googlePlayLink =
      "https://play.google.com/store/apps/details?id=com.sanjoke.loga_parameshwari";
  static const gif3D = "https://sanjay-rb.github.io/ScreenShots/temple_3d.gif";
  static const godImg =
      "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Fgod.webp?alt=media&token=af566403-fd35-47c1-9a64-8a676453d77d";
  static const notificationBanner =
      "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Fbackground.png?alt=media&token=d1316d19-895c-4e0a-a141-1a1fbf4f1ab7";
}

class GKey {
  const GKey();
  static final recentPoojaKey = GlobalKey(debugLabel: 'recentPoojaKey');
  static final addPoojaKey = GlobalKey(debugLabel: 'addPoojaKey');
  static final historyPoojaKey = GlobalKey(debugLabel: 'historyPoojaKey');
  static final mapViewKey = GlobalKey(debugLabel: 'mapViewKey');
  static final profileBtnKey = GlobalKey(debugLabel: 'profileBtnKey');
  static final leafKey = GlobalKey(debugLabel: 'leafKey');
}

// ignore: constant_identifier_names
const SHARE_PREF_TUTORIAL = 'tutorial';
