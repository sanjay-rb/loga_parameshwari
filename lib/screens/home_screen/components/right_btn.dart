import 'package:flutter/material.dart';
import 'package:share/share.dart';

class RightBtn extends StatelessWidget {
  const RightBtn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
      child: TextButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () {
          Share.share(
            "Install Loga Parameshwari Temple Ramassery App \n\n - Get real-time updates of pooja. \n - Make your history with the temple by scheduled pooja. \n - Google map navigation to the temple. \n - Full architecture of temple by the 3D view. \n - Special pooja timetable. \n - And a lot more... \n\n https://play.google.com/store/apps/details?id=com.sanjoke.loga_parameshwari",
          );
        },
        icon: const Icon(Icons.share, color: Colors.white),
        label: const Text(
          "Share",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
