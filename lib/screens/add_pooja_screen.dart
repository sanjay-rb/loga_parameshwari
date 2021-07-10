import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../model/pooja.dart';
import '../services/fire_message_services.dart';

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
  List<Asset> upImages = <Asset>[];
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
              child: Stack(
                children: [
                  ListView(
                    children: [
                      nameForm(node),
                      byForm(node),
                      onForm(),
                      addImages(),
                      if (upImages.isNotEmpty)
                        Text(
                          "Tap on the image to delete",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      Divider(),
                      imageView(),
                      SizedBox(
                        height: 50 + 10.0,
                      ),
                    ],
                  ),
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
                                  "$name on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(on)} Uploading",
                                  style: TextStyle(fontSize: 10),
                                ),
                                content: LinearProgressIndicator(),
                              ),
                            );
                            addPooja();
                          }
                        },
                        child: Text(
                          "Shedule Now",
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
          (index) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      upImages.remove(upImages[index]);
                    });
                  },
                  child: AssetThumb(
                    asset: upImages[index],
                    width: (upImages[index].originalWidth * 0.2).toInt(),
                    height: (upImages[index].originalHeight * 0.2).toInt(),
                  ),
                ),
              )),
    );
  }

  Widget addImages() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: OutlinedButton(
        onPressed: () async {
          upImages = await MultiImagePicker.pickImages(
            maxImages: 500,
            enableCamera: true,
            materialOptions: MaterialOptions(
              actionBarTitle: "Select Images",
              allViewTitle: "All Photos",
              useDetailsView: false,
            ),
            selectedAssets: upImages,
          );
          setState(() {});
          print(upImages);
        },
        child: Text(
          "Add Images",
        ),
      ),
    );
  }

  void errorDialog(context, msg) => showDialog(
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
              child: Text("OK"),
            ),
          ],
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
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
              child: Text("OK"),
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
        ),
      ).then((value) => Navigator.pop(context));

  nameForm(node) => Padding(
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
      );

  byForm(FocusScopeNode node) => Padding(
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
              decoration: InputDecoration(hintText: "Origanizer Name"),
              onEditingComplete: () => node.nextFocus(),
            ),
          ],
        ),
      );

  onForm() => Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Align(
              child: Text("Scheduled on"),
              alignment: Alignment.topLeft,
            ),
            DateTimeField(
              decoration: InputDecoration(hintText: "Date of the Pooja"),
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
                  firstDate: DateTime.now(),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime.now().add(
                    Duration(days: 365 * 3),
                  ),
                );
                if (date != null) {
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

  Future<void> uploadImages(id) async {
    Pooja pooja = Pooja(
      name.trim(),
      by.trim(),
      Timestamp.fromDate(on),
    );
    var year = "${DateFormat("yyyy").format(pooja.on.toDate())}";
    var month = "${DateFormat("MMMM").format(pooja.on.toDate())}";
    Reference rootPath =
        FirebaseStorage.instance.ref().child(year).child(month);
    for (Asset imageFile in upImages) {
      String url = await rootPath
          .child('${pooja.name}+$id')
          .child(imageFile.name)
          .putData(
              (await imageFile.getByteData(quality: 50)).buffer.asUint8List())
          .then((v) => v.ref.getDownloadURL());
      FirebaseFirestore.instance
          .collection("Event")
          .doc(id)
          .collection('Images')
          .doc('${imageFile.name}+$id')
          .set({'url': url});
    }
  }

  void sendMessage() {
    Messaging.send(
      title: "New Pooja named $name is created by $by",
      body: 'on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(on)}',
    ).then((value) {
      Navigator.pop(context);
      if (value.statusCode == 200)
        successDialog(context);
      else
        errorDialog(
            context, "Something went wrong! Message not sent to the members.");
    });
  }

  void addPooja() {
    Map<String, dynamic> newPooja = Pooja(
      name.trim(),
      by.trim(),
      Timestamp.fromDate(on),
    ).toJson();
    newPooja["user"] = AuthService().getUserNumber();
    FirebaseFirestore.instance
        .collection("Event")
        .add(
          newPooja,
        )
        .then((value) async {
      if (upImages.isNotEmpty) {
        await uploadImages(value.id);
      }
      sendMessage();
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      errorDialog(
          context, "Something went wrong! Pooja not posted to the members.");
    });
  }
}
