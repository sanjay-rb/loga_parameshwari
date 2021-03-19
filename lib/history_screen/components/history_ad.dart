import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class HistoryAdComponent extends StatelessWidget {
  final double width;
  final double height;
  HistoryAdComponent({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AdmobBanner(
        adUnitId: "ca-app-pub-4162656890979507/5048868232",
        adSize: AdmobBannerSize.BANNER,
      ),
    );
  }
}
