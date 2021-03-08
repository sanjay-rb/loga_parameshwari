import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class HomeAdComponent extends StatelessWidget {
  final double width;
  final double height;
  HomeAdComponent({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AdmobBanner(
        adUnitId: "ca-app-pub-4162656890979507/5787434520",
        adSize: AdmobBannerSize.BANNER,
      ),
    );
  }
}
