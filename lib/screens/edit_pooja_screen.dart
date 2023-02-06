import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/connectivity_service.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class EditPoojaScreen extends StatefulWidget {
  const EditPoojaScreen({Key key, this.toEditPooja}) : super(key: key);
  final Pooja toEditPooja;

  @override
  _EditPoojaScreenState createState() => _EditPoojaScreenState();
}

class _EditPoojaScreenState extends State<EditPoojaScreen> {
  final addPoojaFormKey = GlobalKey<FormState>();
  String name;
  String by;
  DateTime on;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return IsConnected(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Edit Pooja"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: double.maxFinite,
              child: Form(
                key: addPoojaFormKey,
                child: Column(
                  children: [
                    nameForm(node),
                    byForm(node),
                    onForm(),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (addPoojaFormKey.currentState.validate()) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    "$name on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(on)} Updating",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  content: const LinearProgressIndicator(),
                                ),
                              );
                              DatabaseManager.updatePooja(
                                Pooja(
                                  widget.toEditPooja.id,
                                  name.trim(),
                                  by.trim(),
                                  Timestamp.fromDate(on),
                                  AuthService.getUserNumber(),
                                ),
                              ).then((value) {
                                Navigator.pop(context);
                                successDialog(context);
                              }).onError((error, stackTrace) {
                                Navigator.pop(context);
                                errorDialog(
                                  context,
                                  "Something went wrong! Pooja not posted to the members.",
                                );
                              });
                            }
                          },
                          child: const Text(
                            "Update Data",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void errorDialog(BuildContext context, String msg) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                Text(msg),
              ],
            ),
          ),
        ),
      );

  void successDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.done_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const Text("Done"),
              ],
            ),
          ),
        ),
      ).then(
        (value) => Navigator.of(context).pop(),
      );

  Widget nameForm(FocusScopeNode node) => Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text("Pooja Name"),
            ),
            TextFormField(
              initialValue: widget.toEditPooja.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please give pooja name";
                } else {
                  name = value;
                  return null;
                }
              },
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: "Name"),
              onEditingComplete: () => node.nextFocus(),
            ),
          ],
        ),
      );

  Widget byForm(FocusScopeNode node) => Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text("Organized by"),
            ),
            TextFormField(
              initialValue: widget.toEditPooja.by,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please give your name";
                } else {
                  by = value;
                  return null;
                }
              },
              maxLines: null,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(hintText: "Organizer Name"),
              onEditingComplete: () => node.nextFocus(),
            ),
          ],
        ),
      );

  Widget onForm() => Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text("Scheduled on"),
            ),
            DateTimeField(
              initialValue: widget.toEditPooja.on.toDate(),
              decoration: const InputDecoration(hintText: "Date of the Pooja"),
              validator: (value) {
                if (value == null) {
                  return "Please give date and time";
                } else {
                  on = value;
                  return null;
                }
              },
              format: DateFormat("dd-MM-yyyy hh:mm aaa"),
              onShowPicker: (context, currentValue) async {
                final dateTime = showDatePicker(
                  context: context,
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365 * 3)),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                ).then((date) {
                  if (date != null) {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        currentValue ?? DateTime.now(),
                      ),
                    ).then((time) {
                      return DateTimeField.combine(date, time);
                    });
                    return currentValue;
                  }
                });

                return dateTime;

                // final date = await showDatePicker(
                //   context: context,
                //   firstDate:
                //       DateTime.now().subtract(const Duration(days: 365 * 3)),
                //   initialDate: currentValue ?? DateTime.now(),
                //   lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                // );
                // if (date != null) {
                //   final time = await showTimePicker(
                //     context: context,
                //     initialTime:
                //         TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                //   );
                //   return DateTimeField.combine(date, time);
                // } else {
                //   return currentValue;
                // }
              },
            ),
          ],
        ),
      );
}
