import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String uid;
  String name;
  bool isverified;
  bool isonline;

  UserModel({this.id, this.uid, this.name, this.isverified, this.isonline});

  UserModel.fromJson(QueryDocumentSnapshot<Object> json) {
    final Map data = json.data() as Map;
    id = json.get('id') as String;
    uid = json.get('uid') as String;
    name = json.get('name') as String;
    if (data.keys.contains('isverified') && json.get('isverified') != null) {
      isverified = json.get('isverified') as bool;
    } else {
      isverified = false;
    }
    if (data.keys.contains('isonline') && json.get('isonline') != null) {
      isonline = json.get('isonline') as bool;
    } else {
      isonline = false;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'isverified': isverified,
      'isonline': isonline,
    };
  }
}
