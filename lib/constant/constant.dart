import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/model/pooja.dart';

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
  static getMessageText(Pooja pooja) =>
      "Hi, your invited to *${pooja.name}*\non *${DateFormat("dd MMMM yyyy (hh:mm aaa)").format(pooja.on.toDate())}*\nby *${pooja.by}*.\n\nWe request your gracious presence on this auspicious occasion.";
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
  static final godImg =
      "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Fgod.jpg?alt=media&token=fe7eb4f0-882b-42e7-b94a-461a22cb38ab";
  static final historyImg =
      "https://firebasestorage.googleapis.com/v0/b/loga-parameshwari.appspot.com/o/static%2Fhistory.png?alt=media&token=231b1981-7c7e-4fa2-a21f-108660b74fc3";
}
