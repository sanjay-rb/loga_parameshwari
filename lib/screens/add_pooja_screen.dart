import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loga_parameshwari/model/image.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
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
  List<Asset> upImages = <Asset>[];
  DateTime on;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController byCtrl = TextEditingController();

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
                          "Longpress on the image to delete ❌",
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
                                  "${nameCtrl.text.trim()} on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(on)} Uploading....",
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
            onLongPress: () {
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
        ),
      ),
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
                }
                return null;
              },
              controller: nameCtrl,
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
              controller: byCtrl,
              validator: (value) {
                if (value == null || value.length == 0) {
                  return "Please give your name";
                }
                return null;
              },
              maxLines: null,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
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
              initialValue: on,
              decoration: InputDecoration(hintText: "Date of the Pooja"),
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

  Future<void> uploadImages(Pooja pooja) async {
    var year = "${DateFormat("yyyy").format(pooja.on.toDate())}";
    var month = "${DateFormat("MMMM").format(pooja.on.toDate())}";
    Reference rootPath =
        FirebaseStorage.instance.ref().child(year).child(month);
    for (Asset imageFile in upImages) {
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            "${imageFile.name} Uploading....",
            style: TextStyle(fontSize: 10),
          ),
          content: LinearProgressIndicator(),
        ),
      );
      String url = await rootPath
          .child('${pooja.name}+${pooja.id}')
          .child(imageFile.name)
          .putData(
              (await imageFile.getByteData(quality: 50)).buffer.asUint8List())
          .then((v) => v.ref.getDownloadURL());
      ImageModel imageModel = ImageModel(
        id: DatabaseManager.getUniqueId(),
        like: [],
        pooja: pooja.id,
        url: url,
        user: pooja.user,
      );
      await DatabaseManager.addImage(imageModel);
    }
  }

  void sendMessage() {
    Messaging.send(
      title:
          "New Pooja named ${nameCtrl.text.trim()} by ${byCtrl.text.trim()}}",
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

  Future<void> addPooja() async {
    Pooja pooja = Pooja(
      DatabaseManager.getUniqueId(),
      nameCtrl.text.trim(),
      byCtrl.text.trim(),
      Timestamp.fromDate(on),
      AuthService.getUserNumber(),
    );
    DatabaseManager.addPooja(pooja).then((value) async {
      if (upImages.isNotEmpty) {
        await uploadImages(pooja);
      }
      sendMessage();
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      errorDialog(
          context, "Something went wrong! Pooja not posted to the members.");
    });
  }
}
