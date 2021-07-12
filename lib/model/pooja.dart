import 'package:cloud_firestore/cloud_firestore.dart';

class Pooja {
  String id;
  String name;
  String by;
  Timestamp on;
  String user;

  Pooja(this.id, this.name, this.by, this.on, this.user);

  Pooja.fromJson(json) {
    this.id = json['id'];
    this.name = json['name'];
    this.by = json['by'];
    this.on = json['on'];
    this.user = json['user'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'by': this.by,
      'on': this.on,
      'user': this.user,
    };
  }
}
