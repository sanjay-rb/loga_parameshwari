import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/edit_pooja_screen/edit_pooja_screen.dart';
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
  isPoojaCompleted() =>
      (pooja.on.toDate().difference(DateTime.now()).isNegative);

  editEvent(BuildContext context, Pooja pooja, id) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => EditPoojaScreen(toEditPooja: pooja, toEditId: id)));
  }

  notificationEvent(BuildContext context, Pooja pooja) {
    Messaging.send(
      title: "Reminder to ${pooja.name}",
      body:
          'on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate())}',
    );
  }

  deleteEvent(context, id, Pooja pooja) => () async {
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
          var year = "${DateFormat("yyyy").format(pooja.on.toDate())}";
          var month = "${DateFormat("MMMM").format(pooja.on.toDate())}";
          Reference rootPath = FirebaseStorage.instance
              .ref()
              .child(year)
              .child(month)
              .child('${pooja.name}+$id');
          ListResult storeList = await rootPath.listAll();
          for (Reference item in storeList.items) {
            item.delete();
          }

          DocumentReference rootRef =
              FirebaseFirestore.instance.collection("Event").doc(id);
          QuerySnapshot imageList = await rootRef.collection("Images").get();
          for (QueryDocumentSnapshot item in imageList.docs) {
            rootRef.collection("Images").doc(item.id).delete();
          }

          rootRef.delete();
          Messaging.send(
            title: "Pooja ${pooja.name} is Deleted",
            body:
                'on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate())}',
          );
          Navigator.pop(context);
        }
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${pooja.name}",
          style: TextDesign.headText,
          textAlign: TextAlign.center,
        ),
        Text(
          "by ${pooja.by}",
          style: TextDesign.titleText,
          textAlign: TextAlign.center,
        ),
        Text(
          "${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate())}",
          style: TextDesign.subTitleText,
          textAlign: TextAlign.center,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              !isPoojaCompleted()
                  ? Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextButton.icon(
                        onPressed: () => editEvent(context, pooja, id),
                        icon: Icon(Icons.edit),
                        label: Text("Edit"),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                      ),
                    )
                  : Container(),
              !isPoojaCompleted()
                  ? Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextButton.icon(
                        onPressed: () => notificationEvent(context, pooja),
                        icon: Icon(Icons.notifications_active),
                        label: Text("Reminder"),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextButton.icon(
                  onPressed: () {
                    Share.share(TextDesign.getMessageText(pooja));
                  },
                  icon: Icon(Icons.share),
                  label: Text("Share"),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
              ),
              !isPoojaCompleted()
                  ? Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextButton.icon(
                        onPressed: () => deleteEvent(context, id, pooja),
                        icon: Icon(Icons.delete),
                        label: Text("Delete"),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
