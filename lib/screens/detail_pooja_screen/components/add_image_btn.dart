import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../../model/pooja.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({
    Key key,
    this.pooja,
    this.id,
  }) : super(key: key);
  final Pooja pooja;
  final id;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        List<Asset> upImages = <Asset>[];
        upImages = await MultiImagePicker.pickImages(
          maxImages: 500,
          enableCamera: true,
          materialOptions: MaterialOptions(
            actionBarTitle: "Upload Images",
            allViewTitle: "All Photos",
            useDetailsView: false,
          ),
        );

        var year = "${DateFormat("yyyy").format(pooja.on.toDate())}";
        var month = "${DateFormat("MMMM").format(pooja.on.toDate())}";
        Reference rootPath =
            FirebaseStorage.instance.ref().child(year).child(month);
        for (Asset imageFile in upImages) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                title: Text(
                  "${imageFile.name} Uploading",
                  style: TextStyle(fontSize: 10),
                ),
                content: LinearProgressIndicator()),
          );
          String url = await rootPath
              .child('${pooja.name}+$id')
              .child(imageFile.name)
              .putData((await imageFile.getByteData(quality: 50))
                  .buffer
                  .asUint8List())
              .then((v) => v.ref.getDownloadURL());
          FirebaseFirestore.instance
              .collection("Event")
              .doc(id)
              .collection('Images')
              .doc('${imageFile.name}+$id')
              .set({'url': url});
          Navigator.pop(context);
        }
      },
      child: Icon(Icons.add),
    );
  }
}
