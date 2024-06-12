import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loga_parameshwari/model/image_model.dart';
import 'package:loga_parameshwari/model/pooja_model.dart';
import 'package:loga_parameshwari/services/auth_services.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({
    Key key,
    this.pooja,
  }) : super(key: key);
  final PoojaModel pooja;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      onPressed: () async {
        final ImagePicker picker = ImagePicker();

        picker.pickMultiImage().then((upImages) async {
          final year = DateFormat("yyyy").format(pooja.on.toDate());
          final month = DateFormat("MMMM").format(pooja.on.toDate());
          final Reference rootPath =
              FirebaseStorage.instance.ref().child(year).child(month);
          for (final XFile imageFile in upImages) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text(
                  "${imageFile.name} Uploading",
                  style: const TextStyle(fontSize: 10),
                ),
                content: const LinearProgressIndicator(),
              ),
            );
            final String url = await rootPath
                .child('${pooja.name}+${pooja.id}')
                .child(imageFile.name)
                .putData((await imageFile.readAsBytes()).buffer.asUint8List())
                .then((v) => v.ref.getDownloadURL());
            DatabaseManager.addImage(
              ImageModel(
                id: DatabaseManager.getUniqueId(),
                like: [],
                pooja: pooja.id,
                url: url,
                user: AuthService.getUserNumber(),
              ),
            ).then((value) {
              Navigator.pop(context);
            });
          }
        });
      },
      child: const Icon(Icons.add),
    );
  }
}
