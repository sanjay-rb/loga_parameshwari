import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loga_parameshwari/model/image.dart';
import 'package:loga_parameshwari/model/pooja.dart';
import 'package:loga_parameshwari/services/auth_services.dart';

class DatabaseManager {
  static FirebaseFirestore _db;

  static const String POOJA_COLLECTION_NAME = 'Pooja';
  static const String IMAGE_COLLECTION_NAME = 'Image';

  static init() {
    if (_db == null) {
      _db = FirebaseFirestore.instance;
    }
  }

  static Stream<QuerySnapshot> getRecentPoojaStream() => _db
      .collection(POOJA_COLLECTION_NAME)
      .where('on', isGreaterThanOrEqualTo: Timestamp.now())
      .orderBy('on')
      .snapshots();

  static Stream<QuerySnapshot> getAllPoojaStream() => _db
      .collection(POOJA_COLLECTION_NAME)
      .orderBy('on', descending: true)
      .snapshots();

  static Stream<QuerySnapshot> getImageStreamFromPoojaId(String poojaId) => _db
      .collection(IMAGE_COLLECTION_NAME)
      .where('pooja', isEqualTo: poojaId)
      .snapshots();

  static Stream<DocumentSnapshot> getImageById(String id) =>
      _db.collection(IMAGE_COLLECTION_NAME).doc(id).snapshots();

  static String getUniqueId() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  static addPooja(Pooja pooja) async {
    await _db
        .collection(POOJA_COLLECTION_NAME)
        .doc(pooja.id)
        .set(pooja.toJson());
  }

  static updatePooja(Pooja pooja) async {
    await _db
        .collection(POOJA_COLLECTION_NAME)
        .doc(pooja.id)
        .update(pooja.toJson());
  }

  static deletePooja(Pooja pooja) async {
    await _db.collection(POOJA_COLLECTION_NAME).doc(pooja.id).delete();
    await deleteImage(pooja);
  }

  static addImage(ImageModel image) async {
    await _db
        .collection(IMAGE_COLLECTION_NAME)
        .doc(image.id)
        .set(image.toJson());
  }

  static deleteImage(Pooja pooja) async {
    QuerySnapshot data = await _db
        .collection(IMAGE_COLLECTION_NAME)
        .where('pooja', isEqualTo: pooja.id)
        .get();
    for (QueryDocumentSnapshot i in data.docs) {
      _db.collection(IMAGE_COLLECTION_NAME).doc(i.id).delete();
    }
  }

  static void likeImage(ImageModel imageModel) {
    List like = imageModel.like;
    like.add(AuthService.getUserNumber());
    _db
        .collection(IMAGE_COLLECTION_NAME)
        .doc(imageModel.id)
        .update({"like": like});
  }

  static void unLikeImage(ImageModel imageModel) {
    List like = imageModel.like;
    like.remove(AuthService.getUserNumber());
    _db
        .collection(IMAGE_COLLECTION_NAME)
        .doc(imageModel.id)
        .update({"like": like});
  }
}
