import 'package:cloud_firestore/cloud_firestore.dart';

class Pooja {
  String id;
  String name;
  String by;
  Timestamp on;
  String user;

  Pooja(this.id, this.name, this.by, this.on, this.user);

  Pooja.fromJson(QueryDocumentSnapshot<Object> json) {
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
