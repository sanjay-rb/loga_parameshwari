import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class NoticeBanner extends StatelessWidget {
  const NoticeBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseManager.getNotice(),
      builder: (context, AsyncSnapshot<DocumentSnapshot<Object>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          final String notice = snapshot.data["title"] as String;
          final String description = snapshot.data["description"] as String;
          final Timestamp till = snapshot.data["till"] as Timestamp;
          if (till.compareTo(Timestamp.now()) == 1) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: Colors.red,
                ),
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      notice,
                      style: TextDesign.titleText,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      description,
                      style: TextDesign.subTitleText,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        }
      },
    );
  }
}
