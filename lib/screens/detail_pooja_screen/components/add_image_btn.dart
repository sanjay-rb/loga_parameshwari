import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loga_parameshwari/model/image.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/database_manager.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../../model/pooja.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({
    Key key,
    this.pooja,
  }) : super(key: key);
  final Pooja pooja;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
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
              .child('${pooja.name}+${pooja.id}')
              .child(imageFile.name)
              .putData((await imageFile.getByteData(quality: 50))
                  .buffer
                  .asUint8List())
              .then((v) => v.ref.getDownloadURL());
          DatabaseManager.addImage(
            ImageModel(
              id: DatabaseManager.getUniqueId(),
              like: [],
              pooja: pooja.id,
              url: url,
              user: AuthService.getUserNumber(),
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Icon(Icons.add),
    );
  }
}
