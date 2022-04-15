import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String uid;
  String name;
  UserModel({this.id, this.uid, this.name});
  UserModel.fromJson(QueryDocumentSnapshot<Object> json) {
    id = json['id'] as String;
    uid = json['uid'] as String;
    name = json['name'] as String;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
    };
  }
}
