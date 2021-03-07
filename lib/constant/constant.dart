import 'package:flutter/material.dart';

class TextDesign {
  const TextDesign();
  final headText = const TextStyle(
    fontSize: 25,
  );

  final titleText = const TextStyle(
    fontSize: 20,
  );
}

class CardContainer {
  const CardContainer();
  final borderRadius = const BorderRadius.all(
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
