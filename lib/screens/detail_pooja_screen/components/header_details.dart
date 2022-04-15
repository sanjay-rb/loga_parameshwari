import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/constant/constant.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:loga_parameshwari/screens/edit_pooja_screen.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:loga_parameshwari/services/fire_message_services.dart';
import 'package:loga_parameshwari/services/navigation_animation_services.dart';
import 'package:share/share.dart';

class HeaderDetails extends StatelessWidget {
  const HeaderDetails({
    Key key,
    this.pooja,
  }) : super(key: key);

  final Pooja pooja;
  bool isMyPooja() => pooja.user == AuthService.getUserNumber();

  void editEvent(BuildContext context, Pooja pooja) {
    Navigator.of(context).pushReplacement(
      NavigationAnimationService.fadePageRoute(
        enterPage: EditPoojaScreen(toEditPooja: pooja),
      ),
    );
  }

  void notificationEvent(BuildContext context, Pooja pooja) {
    Messaging.send(
      title: "Reminder to ${pooja.name}",
      body:
          'on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate())}',
    );
  }

  Future<void> deleteEvent(BuildContext context, Pooja pooja) async {
    final bool boolVal = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Oops! You're deleting the event?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(
              "Yes, I'm",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text(
              "Nope",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
    if (boolVal != null && boolVal) {
      final year = DateFormat("yyyy").format(pooja.on.toDate());
      final month = DateFormat("MMMM").format(pooja.on.toDate());
      final Reference rootPath = FirebaseStorage.instance
          .ref()
          .child(year)
          .child(month)
          .child('${pooja.name}+${pooja.id}');
      if (kDebugMode) {
        print("rootPath.name ${rootPath.name}");
      }
      final ListResult storeList = await rootPath.listAll();
      if (kDebugMode) {
        print("storeList ${storeList.items}");
      }
      for (final Reference item in storeList.items) {
        item.delete();
      }

      DatabaseManager.deletePooja(pooja).then((value) {
        Messaging.send(
          title: "Pooja ${pooja.name} is Deleted",
          body:
              'on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate())}',
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          pooja.name,
          style: TextDesign.headText,
          textAlign: TextAlign.center,
        ),
        const Text(
          "Sponsor by",
          style: TextDesign.titleText,
          textAlign: TextAlign.center,
        ),
        ...List.generate(
          pooja.by.split('\n').length,
          (i) => Text(
            "⚈ ${pooja.by.split('\n')[i]}",
            style: TextDesign.subTitleText,
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          DateFormat("dd-MM-yyyy (hh:mm aaa)").format(pooja.on.toDate()),
          style: TextDesign.titleText,
          textAlign: TextAlign.center,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isMyPooja())
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextButton.icon(
                    onPressed: () => editEvent(context, pooja),
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                  ),
                )
              else
                Container(),
              if (isMyPooja())
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextButton.icon(
                    onPressed: () => notificationEvent(context, pooja),
                    icon: const Icon(Icons.notifications_active),
                    label: const Text("Reminder"),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                  ),
                )
              else
                Container(),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextButton.icon(
                  onPressed: () {
                    Share.share(TextDesign.getMessageText(pooja));
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("Share"),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
              ),
              if (isMyPooja())
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextButton.icon(
                    onPressed: () {
                      deleteEvent(context, pooja);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                  ),
                )
              else
                Container(),
            ],
          ),
        ),
      ],
    );
  }
}
