import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';

class HeadComponent extends StatelessWidget {
  final double width;
  final double height;
  const HeadComponent({Key key, this.width, this.height}) : super(key: key);
  final TextDesign td = const TextDesign();

  String getGreeting() {
    if (DateTime.now().hour >= 3 && DateTime.now().hour < 12) {
      return "Good Morning";
    } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 5) {
      return "Good Afternoon";
    } else if (DateTime.now().hour >= 5 && DateTime.now().hour < 8) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Loga Parameshwari Thunai",
            style: td.headText,
            textAlign: TextAlign.right,
          ),
          Text(
            getGreeting(),
            style: td.titleText,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
