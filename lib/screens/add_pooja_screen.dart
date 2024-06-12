import 'dart:io' as io;
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/model/image_model.dart';
import 'package:loga_parameshwari/model/pooja_model.dart';
import 'package:loga_parameshwari/model/user_model.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/connectivity_service.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class AddPoojaScreen extends StatefulWidget {
  const AddPoojaScreen({Key key}) : super(key: key);

  @override
  _AddPoojaScreenState createState() => _AddPoojaScreenState();
}

class _AddPoojaScreenState extends State<AddPoojaScreen> {
  final addPoojaFormKey = GlobalKey<FormState>();
  List<XFile> upImages = <XFile>[];
  DateTime on;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController byCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return IsConnected(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Schedule Pooja"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: double.maxFinite,
              child: Form(
                key: addPoojaFormKey,
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        nameForm(node),
                        byForm(node),
                        onForm(),
                        addImages(),
                        if (upImages.isNotEmpty)
                          const Text(
                            "Long press on the image to delete ❌",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        const Divider(),
                        imageView(),
                        const SizedBox(
                          height: 50 + 10.0,
                        ),
                      ],
                    ),
                    FutureBuilder<QuerySnapshot>(
                      future: DatabaseManager.getUserInfoById(
                        AuthService.getUserNumber(),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        UserModel user;
                        if (snapshot.data.docs.length == 1) {
                          user = UserModel.fromJson(snapshot.data.docs.first);
                        }

                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (user != null && user.isverified)
                                Container()
                              else
                                Text(
                                  "Hi ${user.name}, you cannot create pooja right now, please contact Poojari or Developer.",
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              SizedBox(
                                width: double.maxFinite,
                                height: 50,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      (user != null && user.isverified)
                                          ? Colors.amber
                                          : Colors.grey,
                                    ),
                                  ),
                                  onPressed: (user != null && user.isverified)
                                      ? () {
                                          if (addPoojaFormKey.currentState
                                              .validate()) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  "${nameCtrl.text.trim()} on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(on)} Uploading....",
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                content:
                                                    const LinearProgressIndicator(),
                                              ),
                                            );
                                            addPooja();
                                          }
                                        }
                                      : () {},
                                  child: const Text(
                                    "Schedule Now",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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

  Widget imageView() {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: List.generate(
        upImages.length,
        (index) {
          final io.File imageFile = io.File(upImages[index].path);

          return FutureBuilder<ui.Image>(
            future: decodeImageFromList(imageFile.readAsBytesSync()),
            builder: (context, snapshot) {
              final ui.Image image = snapshot.data;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return Material(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onLongPress: () {
                    setState(() {
                      upImages.remove(upImages[index]);
                    });
                  },
                  child: SizedBox(
                    width: image.width * 0.2,
                    height: image.height * 0.2,
                    child: Image.file(
                      io.File(upImages[index].path),
                      key: ValueKey(upImages[index].name),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget addImages() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: OutlinedButton(
        onPressed: () async {
          final ImagePicker picker = ImagePicker();
          upImages = await picker.pickMultiImage();
          setState(() {});
        },
        child: const Text(
          "Add Images",
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
      ).then((value) => Navigator.pop(context));

  Widget nameForm(FocusScopeNode node) => Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text("Pooja Name"),
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please give pooja name";
                }
                return null;
              },
              controller: nameCtrl,
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
              controller: byCtrl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please give your name";
                }
                return null;
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
              initialValue: on,
              decoration: const InputDecoration(hintText: "Date of the Pooja"),
              validator: (value) {
                if (value == null) {
                  return "Please give date and time";
                }
                return null;
              },
              onChanged: (val) {
                on = val;
              },
              format: DateFormat("dd-MM-yyyy hh:mm aaa"),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 365 * 3),
                  ),
                );
                if (date != null) {
                  // ignore: use_build_context_synchronously
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
            ),
          ],
        ),
      );

  Future<void> uploadImages(PoojaModel pooja) async {
    final year = DateFormat("yyyy").format(pooja.on.toDate());
    final month = DateFormat("MMMM").format(pooja.on.toDate());
    final Reference rootPath =
        FirebaseStorage.instance.ref().child(year).child(month);
    for (final XFile imageFile in upImages) {
      // Navigator.pop(context);
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => AlertDialog(
      //     title: Text(
      //       "${imageFile.name} Uploading....",
      //       style: const TextStyle(fontSize: 10),
      //     ),
      //     content: const LinearProgressIndicator(),
      //   ),
      // );
      final String url = await rootPath
          .child('${pooja.name}+${pooja.id}')
          .child(imageFile.name)
          .putData((await imageFile.readAsBytes()).buffer.asUint8List())
          .then((v) => v.ref.getDownloadURL());
      final ImageModel imageModel = ImageModel(
        id: DatabaseManager.getUniqueId(),
        like: [],
        pooja: pooja.id,
        url: url,
        user: pooja.user,
      );
      await DatabaseManager.addImage(imageModel);
    }
  }

  Future<void> addPooja() async {
    final PoojaModel pooja = PoojaModel(
      DatabaseManager.getUniqueId(),
      nameCtrl.text.trim(),
      byCtrl.text.trim(),
      Timestamp.fromDate(on),
      AuthService.getUserNumber(),
    );
    await DatabaseManager.addPooja(pooja).onError((error, stackTrace) {
      Navigator.pop(context); // Pop Upload Dialog & Show Error Dialog
      errorDialog(
        context,
        "Something went wrong while creating new pooja! Pooja not posted to the members.",
      );
    });
    await uploadImages(pooja).onError((error, stackTrace) {
      Navigator.pop(context); // Pop Upload Dialog & Show Error Dialog
      errorDialog(
        context,
        "Something went wrong while uploading images! Pooja not posted to the members.",
      );
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context); // Pop upload dialog once uploaded

    // ignore: use_build_context_synchronously
    Navigator.pop(context); // Pop Back to Home Screen
  }
}
