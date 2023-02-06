import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loga_parameshwari/services/database_manager.dart';

class UserModel {
  final collectionName = "User";
  String id;
  String uid;
  String name;
  bool isverified;
  bool isonline;

  UserModel({this.id, this.uid, this.name, this.isverified, this.isonline});

  Stream<List<UserModel>> getOnlineUsers() {
    return DatabaseManager()
        .db
        .collection(collectionName)
        .where('isonline', isEqualTo: true)
        .snapshots()
        .map((QuerySnapshot event) {
      return event.docs.map((e) => UserModel.fromJson(e)).toList();
    });
  }

  UserModel.fromJson(QueryDocumentSnapshot<Object> json) {
    debugPrint("${json.data()}");
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
