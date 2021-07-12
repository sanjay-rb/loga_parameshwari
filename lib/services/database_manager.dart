import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loga_parameshwari/model/image.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:loga_parameshwari/services/auth_services.dart';

class DatabaseManager {
  static FirebaseFirestore _db;

  static init() {
    if (_db == null) {
      _db = FirebaseFirestore.instance;
    }
  }

  static addPooja(Pooja pooja) async {
    await _db.collection("Pooja").doc(pooja.id).set(pooja.toJson());
  }

  static updatePooja(Pooja pooja) async {
    await _db.collection("Pooja").doc(pooja.id).update(pooja.toJson());
  }

  static deletePooja(Pooja pooja) async {
    await _db.collection("Pooja").doc(pooja.id).delete();
    await deleteImage(pooja);
  }

  static addImage(ImageModel image) async {
    await _db.collection("Image").doc(image.id).set(image.toJson());
  }

  static deleteImage(Pooja pooja) async {
    QuerySnapshot data =
        await _db.collection("Image").where('pooja', isEqualTo: pooja.id).get();
    for (QueryDocumentSnapshot i in data.docs) {
      _db.collection("Image").doc(i.id).delete();
    }
  }

  static Stream<DocumentSnapshot> getImageById(String id) {
    return _db.collection("Image").doc(id).snapshots();
  }

  static void likeImage(ImageModel imageModel) {
    List like = imageModel.like;
    like.add(AuthService.getUserNumber());
    _db.collection("Image").doc(imageModel.id).update({"like": like});
  }

  static void unLikeImage(ImageModel imageModel) {
    List like = imageModel.like;
    like.remove(AuthService.getUserNumber());
    _db.collection("Image").doc(imageModel.id).update({"like": like});
  }

  static Stream<QuerySnapshot> getImageStreamFromPoojaId(String poojaId) {
    return _db
        .collection("Image")
        .where('pooja', isEqualTo: poojaId)
        .snapshots();
  }

  static Stream<QuerySnapshot> getRecentPoojaStream() {
    return _db
        .collection('Pooja')
        .where('on', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('on')
        .snapshots();
  }

  static Stream<QuerySnapshot> getAllPoojaStream() {
    return _db
        .collection('Pooja')
        .orderBy(
          'on',
          descending: true,
        )
        .snapshots();
  }

  static String getUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
