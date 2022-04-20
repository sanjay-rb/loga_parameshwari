import 'package:flutter/material.dart';

import 'package:loga_parameshwari/constant/constant.dart';

class HeadComponent extends StatelessWidget {
  const HeadComponent({Key key}) : super(key: key);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "Loga Parameshwari Thunai",
          style: TextDesign.headText,
          textAlign: TextAlign.right,
        ),
        StreamBuilder<String>(
          stream: getGreeting(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                "Loading...",
                style: TextDesign.titleText,
                textAlign: TextAlign.right,
              );
            } else {
              return Text(
                snapshot.data,
                style: TextDesign.titleText,
                textAlign: TextAlign.right,
              );
            }
          },
        ),
      ],
    );
  }
}
