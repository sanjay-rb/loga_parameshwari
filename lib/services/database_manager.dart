// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loga_parameshwari/model/image_model.dart';
import 'package:loga_parameshwari/model/pooja_model.dart';
import 'package:loga_parameshwari/model/user_model.dart';
import 'package:loga_parameshwari/services/auth_services.dart';

class DatabaseManager {
  String tag = "DatabaseManager";
  static FirebaseFirestore _db;
  FirebaseFirestore get db => _db;
  static const String POOJA_COLLECTION_NAME = 'Pooja';
  static const String IMAGE_COLLECTION_NAME = 'Image';
  static const String USER_COLLECTION_NAME = 'User';
  static const String NOTICE_COLLECTION_NAME = 'Notice';
  static const String DONATION_COLLECTION_NAME = 'DonationDetails';
  static const String CONTACT_COLLECTION_NAME = 'Contact';

  static Future<void> init() async {
    _db ??= FirebaseFirestore.instance;
  }

  static Stream<QuerySnapshot> getContactInfo() =>
      _db.collection(CONTACT_COLLECTION_NAME).snapshots();

  static Stream<DocumentSnapshot> getAccountDetails() =>
      _db.collection(DONATION_COLLECTION_NAME).doc('account').snapshots();

  static Stream<DocumentSnapshot> getNotice() =>
      _db.collection(NOTICE_COLLECTION_NAME).doc('notice').snapshots();

  static Stream<QuerySnapshot> getRecentPoojaStream() => _db
      .collection(POOJA_COLLECTION_NAME)
      .where('on', isGreaterThanOrEqualTo: Timestamp.now())
      .orderBy('on')
      .snapshots();

  static Stream<QuerySnapshot> getAllPoojaStream() => _db
      .collection(POOJA_COLLECTION_NAME)
      .orderBy('on', descending: true)
      .snapshots();

  static Future<QuerySnapshot> getLimitedPooja(int limit) => _db
      .collection(POOJA_COLLECTION_NAME)
      .orderBy('on', descending: true)
      .limit(limit)
      .get();

  static Stream<QuerySnapshot> getImageStreamFromPoojaId(String poojaId) => _db
      .collection(IMAGE_COLLECTION_NAME)
      .where('pooja', isEqualTo: poojaId)
      .snapshots();

  static Future<QuerySnapshot> getUserInfo() => _db
      .collection(USER_COLLECTION_NAME)
      .where('id', isEqualTo: AuthService.getUserNumber())
      .get();

  static Future<QuerySnapshot> getUserInfoById(String id) => _db
      .collection(USER_COLLECTION_NAME)
      .where('id', isEqualTo: id)
      .limit(1)
      .get();

  static Stream<DocumentSnapshot> getImageById(String id) =>
      _db.collection(IMAGE_COLLECTION_NAME).doc(id).snapshots();

  static String getUniqueId() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  static Future<void> addUser(UserModel userModel) async {
    await _db
        .collection(USER_COLLECTION_NAME)
        .doc(userModel.id)
        .set(userModel.toJson());
  }

  static Future<PoojaModel> getPoojaByID(String id) async {
    final DocumentSnapshot snapshot =
        await _db.collection(POOJA_COLLECTION_NAME).doc(id).get();
    final PoojaModel pooja = PoojaModel.fromJson(snapshot);
    return pooja;
  }

  static Future<void> addPooja(PoojaModel pooja) async {
    await _db
        .collection(POOJA_COLLECTION_NAME)
        .doc(pooja.id)
        .set(pooja.toJson());
  }

  static Future<void> updatePooja(PoojaModel pooja) async {
    await _db
        .collection(POOJA_COLLECTION_NAME)
        .doc(pooja.id)
        .update(pooja.toJson());
  }

  static Future<void> deletePooja(PoojaModel pooja) async {
    await _db.collection(POOJA_COLLECTION_NAME).doc(pooja.id).delete();
    await deleteImage(pooja);
  }

  static Future<void> addImage(ImageModel image) async {
    await _db
        .collection(IMAGE_COLLECTION_NAME)
        .doc(image.id)
        .set(image.toJson());
  }

  static Future<void> deleteImage(PoojaModel pooja) async {
    final QuerySnapshot data = await _db
        .collection(IMAGE_COLLECTION_NAME)
        .where('pooja', isEqualTo: pooja.id)
        .get();
    for (final QueryDocumentSnapshot i in data.docs) {
      await _db.collection(IMAGE_COLLECTION_NAME).doc(i.id).delete();
    }
  }

  static Future<void> likeImage(ImageModel imageModel) async {
    final List like = imageModel.like;
    like.add(AuthService.getUserNumber());
    await _db
        .collection(IMAGE_COLLECTION_NAME)
        .doc(imageModel.id)
        .update({"like": like});
  }

  static Future<void> unLikeImage(ImageModel imageModel) async {
    final List like = imageModel.like;
    like.remove(AuthService.getUserNumber());
    await _db
        .collection(IMAGE_COLLECTION_NAME)
        .doc(imageModel.id)
        .update({"like": like});
  }
}
