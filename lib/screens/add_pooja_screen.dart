import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/model/image.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:loga_parameshwari/model/user.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/connectivity_service.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:loga_parameshwari/services/fire_message_services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
                            style: TextStyle(fontSize: 10, color: Colors.grey),
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
            materialOptions: const MaterialOptions(
              actionBarTitle: "Select Images",
              allViewTitle: "All Photos",
              useDetailsView: false,
            ),
            selectedAssets: upImages,
          );
          setState(() {});
          debugPrint(upImages.toString());
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
    final year = DateFormat("yyyy").format(pooja.on.toDate());
    final month = DateFormat("MMMM").format(pooja.on.toDate());
    final Reference rootPath =
        FirebaseStorage.instance.ref().child(year).child(month);
    for (final Asset imageFile in upImages) {
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            "${imageFile.name} Uploading....",
            style: const TextStyle(fontSize: 10),
          ),
          content: const LinearProgressIndicator(),
        ),
      );
      final String url = await rootPath
          .child('${pooja.name}+${pooja.id}')
          .child(imageFile.name)
          .putData(
            (await imageFile.getByteData(quality: 50)).buffer.asUint8List(),
          )
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

  void sendMessage() {
    Messaging.send(
      title: "New Pooja named ${nameCtrl.text.trim()} by ${byCtrl.text.trim()}",
      body: 'on ${DateFormat("dd-MM-yyyy (hh:mm aaa)").format(on)}',
    ).then((value) {
      Navigator.pop(context);
      if (value.statusCode == 200) {
        successDialog(context);
      } else {
        errorDialog(
          context,
          "Something went wrong! Message not sent to the members.",
        );
      }
    });
  }

  Future<void> addPooja() async {
    final Pooja pooja = Pooja(
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
        context,
        "Something went wrong! Pooja not posted to the members.",
      );
    });
  }
}
