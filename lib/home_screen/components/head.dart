import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';

class HeadComponent extends StatelessWidget {
  const HeadComponent({Key key}) : super(key: key);
  final TextDesign td = const TextDesign();

  Stream<String> getGreeting() async* {
    if (DateTime.now().hour >= 3 && DateTime.now().hour < 12) {
      yield "Good Morning";
    } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 17) {
      yield "Good Afternoon";
    } else if (DateTime.now().hour >= 17 && DateTime.now().hour < 20) {
      yield "Good Evening";
    } else {
      yield "Good Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Loga Parameshwari Thunai",
            style: td.headText,
            textAlign: TextAlign.right,
          ),
          StreamBuilder<String>(
            stream: getGreeting(),
            builder: (context, snapshot) {
              return Text(
                snapshot.data.toString(),
                style: td.titleText,
                textAlign: TextAlign.right,
              );
            },
          ),
        ],
      ),
    );
  }
}
