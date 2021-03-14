import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/model/pooja.dart';

class AddPoojaScreen extends StatefulWidget {
  const AddPoojaScreen({Key key}) : super(key: key);

  @override
  _AddPoojaScreenState createState() => _AddPoojaScreenState();
}

class _AddPoojaScreenState extends State<AddPoojaScreen> {
  final addPoojaFormKey = GlobalKey<FormState>();
  String name;
  String by;
  DateTime on;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Schedule Pooja"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: double.maxFinite,
            child: Form(
              key: addPoojaFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Align(
                          child: Text("Pooja Name"),
                          alignment: Alignment.topLeft,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return "Please give pooja name";
                            } else {
                              name = value;
                              return null;
                            }
                          },
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(hintText: "Name"),
                          onEditingComplete: () => node.nextFocus(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Align(
                          child: Text("Origanized by"),
                          alignment: Alignment.topLeft,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return "Please give your name";
                            } else {
                              by = value;
                              return null;
                            }
                          },
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "Origanizer Name"),
                          onEditingComplete: () => node.unfocus(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Align(
                          child: Text("Scheduled on"),
                          alignment: Alignment.topLeft,
                        ),
                        DateTimeField(
                          decoration:
                              InputDecoration(hintText: "Date of the Pooja"),
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
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.combine(date, time);
                            } else {
                              return currentValue;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (addPoojaFormKey.currentState.validate()) {
                            FirebaseFirestore.instance
                                .collection("Event")
                                .add(
                                  Pooja(name, by, Timestamp.fromDate(on))
                                      .toJson(),
                                )
                                .then((value) {
                              /**
                                   Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    String constructFCMPayload(String token) {
  _messageCount++;
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
  });
}

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }
                                   */
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.done_rounded,
                                          size: 80,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text("Done"),
                                    ],
                                  ),
                                ),
                              ).then((value) => Navigator.pop(context));
                            }).onError((error, stackTrace) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                  content: Container(
                                    height: 190,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.error,
                                            size: 80,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                            "Somthing went Wrong! Please try again."),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          }
                        },
                        child: Text(
                          "Shedule Now",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
