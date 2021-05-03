import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/fire_message/fire_message.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:share/share.dart';

class HeaderDetails extends StatelessWidget {
  const HeaderDetails({
    Key key,
    this.pooja,
    this.id,
  }) : super(key: key);

  final Pooja pooja;
  final id;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${pooja.name}",
          style: TextDesign.headText,
        ),
        Text(
          "by ${pooja.by}",
          style: TextDesign.titleText,
        ),
        Text(
          "${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate())}",
          style: TextDesign.subTitleText,
        ),
        Row(
          children: [
            Spacer(),
            TextButton.icon(
              onPressed: () {
                Share.share(TextDesign.getMessageText(pooja));
              },
              icon: Icon(Icons.share),
              label: Text("Share"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
            ),
            TextButton.icon(
              onPressed: deleteEvent(context, id, pooja),
              icon: Icon(Icons.delete),
              label: Text("Delete"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

deleteEvent(context, id, pooja) => () async {
      bool boolVal = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Oops! You're deleting the event?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                "Yes, I'm",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                "Nope",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );
      if (boolVal != null && boolVal) {
        FirebaseFirestore.instance.collection("Event").doc(id).delete();
        Messaging.send(
          title: pooja.name,
          body:
              '${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate())} was deleted.',
        );
        Navigator.pop(context);
      }
    };
