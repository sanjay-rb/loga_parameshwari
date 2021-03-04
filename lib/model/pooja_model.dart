import 'package:cloud_firestore/cloud_firestore.dart';

class PoojaModel {
  String id;
  String name;
  String by;
  Timestamp on;
  String user;

  PoojaModel(this.id, this.name, this.by, this.on, this.user);

  PoojaModel.fromJson(DocumentSnapshot<Object> json) {
    id = json['id'] as String;
    name = json['name'] as String;
    by = json['by'] as String;
    on = json['on'] as Timestamp;
    user = json['user'] as String;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'by': by,
      'on': on,
      'user': user,
    };
  }
}
