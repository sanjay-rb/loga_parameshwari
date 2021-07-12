import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:loga_parameshwari/services/navigation_animation_services.dart';
import 'package:share/share.dart';

import '../../edit_pooja_screen.dart';
import '../../../model/pooja.dart';
import '../../../constant/constant.dart';
import '../../../services/fire_message_services.dart';

class HeaderDetails extends StatelessWidget {
  const HeaderDetails({
    Key key,
    this.pooja,
  }) : super(key: key);

  final Pooja pooja;
  bool isMyPooja() => (pooja.user == AuthService.getUserNumber());

  editEvent(BuildContext context, Pooja pooja) {
    Navigator.of(context).pushReplacement(
      NavigationAnimationService.fadePageRoute(
        enterPage: EditPoojaScreen(toEditPooja: pooja),
      ),
    );
  }

  notificationEvent(BuildContext context, Pooja pooja) {
    Messaging.send(
      title: "Reminder to ${pooja.name}",
      body:
          'on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate())}',
    );
  }

  deleteEvent(context, Pooja pooja) async {
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
          .child('${pooja.name}+${pooja.id}');
      print("rootPath.name ${rootPath.name}");
      ListResult storeList = await rootPath.listAll();
      print("storeList ${storeList.items}");
      for (Reference item in storeList.items) {
        item.delete();
      }

      await DatabaseManager.deletePooja(pooja);

      Messaging.send(
        title: "Pooja ${pooja.name} is Deleted",
        body:
            'on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate())}',
      );
      Navigator.pop(context);
    }
  }

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
              isMyPooja()
                  ? Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextButton.icon(
                        onPressed: () => editEvent(context, pooja),
                        icon: Icon(Icons.edit),
                        label: Text("Edit"),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                      ),
                    )
                  : Container(),
              isMyPooja()
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
              isMyPooja()
                  ? Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextButton.icon(
                        onPressed: () {
                          deleteEvent(context, pooja);
                        },
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
