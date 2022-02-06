import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/pooja.dart';

class TextDesign {
  const TextDesign();
  static final headText = const TextStyle(
    fontSize: 25,
  );

  static final titleText = const TextStyle(
    fontSize: 20,
  );
  static final subTitleText = const TextStyle(
    fontSize: 15,
  );

  static const msgKey =
      "AAAAZCPfm4I:APA91bHfQkiVDflbWTHDlf6tZPASoa41uKXQkxiOjRSpCezcNdiiiMLT1tIvNOGBbUvqckjSq8mE2pMHURP8Qeo8Nm5QkYwtrfe0pW7hbhJ9dwcWzLuTTcLVw9b5K1SIqHUEusREdoN4";
  static getMessageText(Pooja pooja) =>
      "Hi, your invited to *${pooja.name.trim()}*\non *${DateFormat("dd MMMM yyyy (hh:mm aaa)").format(pooja.on.toDate())}*\nby *${pooja.by.trim()}*.\n\nWe request your gracious presence on this auspicious occasion. \n\n https://sanjoke.page.link/loga_parameshwari_app Click the link for further information.";
}

class CardContainer {
  static final borderRadius = const BorderRadius.all(
    Radius.circular(20),
  );
}

class ImagesAndUrls {
  const ImagesAndUrls();
  static final mapImg =
      "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Flocation.png?alt=media&token=a1527275-6659-47a7-b7a5-a67fc9c71ec3";
  static final mapUrl = "https://goo.gl/maps/dTXWo6dTdQ8Bgsi28";
  static final historyImg =
      "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Fhistory.png?alt=media&token=231b1981-7c7e-4fa2-a21f-108660b74fc3";
  static final logoImg =
      "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Flogo.png?alt=media&token=830a8425-ccea-4d0e-9b2d-bd3fbfd4e385";
  static final googlePlayLink =
      "https://play.google.com/store/apps/details?id=com.sanjoke.loga_parameshwari";
  static final gif3D =
      "https://sanjay-rb.github.io/ScreenShots/temple_3d.gif";
  static final godImg =
      "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Fgod.webp?alt=media&token=af566403-fd35-47c1-9a64-8a676453d77d";
}
