import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class BtnAdComponent extends StatelessWidget {
  const BtnAdComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AdmobBanner(
        adUnitId: "ca-app-pub-4162656890979507/3579873891",
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      ),
    );
  }
}
